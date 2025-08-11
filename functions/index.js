const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.notifyCertificateStatusChange = functions.firestore
    .document("certificates/{userId}/certificates/{certificateId}")
    .onWrite(async(change, context) => {
        const { userId, certificateId } = context.params;

        const fcmTokenSnap = await admin
            .firestore()
            .collection("users")
            .doc(userId)
            .get();
        if (!fcmTokenSnap.exists) {
            console.log("User not found:", userId);
            return null;
        }

        const fcmToken = fcmTokenSnap.data().fcmToken;
        if (!fcmToken) {
            console.log("FCM token missing for user:", userId);
            return null;
        }

        // Document DELETED → Disapproved case
        if (!change.after.exists) {
            const message = {
                token: fcmToken,
                notification: {
                    title: "❌ Certificate Disapproved",
                    body: `Your certificate has been disapproved and removed.`,
                },
            };

            try {
                await admin.messaging().send(message);
                console.log("Disapproval notification sent to:", userId);
            } catch (error) {
                console.error("Error sending disapproval notification:", error);
            }

            return null;
        }

        // Document UPDATED → Status changed
        const beforeStatus = change.before.data().status;
        const afterStatus = change.after.data().status;

        if (beforeStatus === afterStatus || !afterStatus) return null;

        if (afterStatus === "true") {
            const message = {
                token: fcmToken,
                notification: {
                    title: "🎉 Certificate Approved",
                    body: `Your certificate has been approved.`,
                },
            };

            try {
                await admin.messaging().send(message);
                console.log("Approval notification sent to:", userId);
            } catch (error) {
                console.error("Error sending approval notification:", error);
            }
        }

        return null;
    });



exports.notifyNewMessage = functions.firestore
    .document("chats/{chatId}/messages/{messageId}")
    .onCreate(async(snap, context) => {
        const messageData = snap.data();
        const { senderId, receiverId, text } = messageData;

        // Get receiver's FCM token
        const receiverDoc = await admin
            .firestore()
            .collection("users")
            .doc(receiverId)
            .get();
        if (!receiverDoc.exists) {
            console.log("Receiver not found:", receiverId);
            return null;
        }

        const fcmToken = receiverDoc.data().fcmToken;
        if (!fcmToken) {
            console.log("No FCM token for receiver:", receiverId);
            return null;
        }

        // Get sender's name for notification
        const senderDoc = await admin
            .firestore()
            .collection("users")
            .doc(senderId)
            .get();
        const senderName = senderDoc.exists ?
            senderDoc.data().name || "Someone" :
            "Someone";

        // Prepare push notification
        const message = {
            token: fcmToken,
            notification: {
                title: `💬 New Message from ${senderName}`,
                body: text.length > 50 ? text.substring(0, 50) + "..." : text,
            },
            data: {
                chatId: context.params.chatId,
                senderId: senderId,
            },
        };

        try {
            await admin.messaging().send(message);
            console.log(`Message notification sent to ${receiverId}`);
        } catch (error) {
            console.error("Error sending notification:", error);
        }

        return null;
    });