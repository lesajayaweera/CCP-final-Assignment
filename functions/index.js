const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyCertificateStatusChange = functions.firestore
    .document('certificates/{userId}/certificates/{certificateId}')
    .onWrite(async(change, context) => {
        const { userId, certificateId } = context.params;

        const fcmTokenSnap = await admin.firestore().collection('users').doc(userId).get();
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