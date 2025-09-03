    // const functions = require("firebase-functions");
    // const admin = require("firebase-admin");
    // admin.initializeApp();

    // exports.notifyCertificateStatusChange = functions.firestore
    //     .document("certificates/{userId}/certificates/{certificateId}")
    //     .onWrite(async(change, context) => {
    //         const { userId, certificateId } = context.params;

    //         const fcmTokenSnap = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(userId)
    //             .get();
    //         if (!fcmTokenSnap.exists) {
    //             console.log("User not found:", userId);
    //             return null;
    //         }

    //         const fcmToken = fcmTokenSnap.data().fcmToken;
    //         if (!fcmToken) {
    //             console.log("FCM token missing for user:", userId);
    //             return null;
    //         }

    //         // Document DELETED → Disapproved case
    //         if (!change.after.exists) {
    //             const message = {
    //                 token: fcmToken,
    //                 notification: {
    //                     title: "❌ Certificate Disapproved",
    //                     body: `Your certificate has been disapproved and removed.`,
    //                 },
    //             };

    //             try {
    //                 await admin.messaging().send(message);
    //                 console.log("Disapproval notification sent to:", userId);
    //             } catch (error) {
    //                 console.error("Error sending disapproval notification:", error);
    //             }

    //             return null;
    //         }

    //         // Document UPDATED → Status changed
    //         const beforeStatus = change.before.data().status;
    //         const afterStatus = change.after.data().status;

    //         if (beforeStatus === afterStatus || !afterStatus) return null;

    //         if (afterStatus === "true") {
    //             const message = {
    //                 token: fcmToken,
    //                 notification: {
    //                     title: "🎉 Certificate Approved",
    //                     body: `Your certificate has been approved.`,
    //                 },
    //             };

    //             try {
    //                 await admin.messaging().send(message);
    //                 console.log("Approval notification sent to:", userId);
    //             } catch (error) {
    //                 console.error("Error sending approval notification:", error);
    //             }
    //         }

    //         return null;
    //     });

    // exports.notifyNewMessage = functions.firestore
    //     .document("chats/{chatId}/messages/{messageId}")
    //     .onCreate(async(snap, context) => {
    //         const messageData = snap.data();
    //         const { senderId, receiverId, text } = messageData;

    //         // Get receiver's FCM token
    //         const receiverDoc = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(receiverId)
    //             .get();
    //         if (!receiverDoc.exists) {
    //             console.log("Receiver not found:", receiverId);
    //             return null;
    //         }

    //         const fcmToken = receiverDoc.data().fcmToken;
    //         if (!fcmToken) {
    //             console.log("No FCM token for receiver:", receiverId);
    //             return null;
    //         }

    //         // Get sender's name for notification
    //         const senderDoc = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(senderId)
    //             .get();
    //         const senderName = senderDoc.exists ?
    //             senderDoc.data().name || "Someone" :
    //             "Someone";

    //         // Prepare push notification
    //         const message = {
    //             token: fcmToken,
    //             notification: {
    //                 title: `💬 New Message from ${senderName}`,
    //                 body: text.length > 50 ? text.substring(0, 50) + "..." : text,
    //             },
    //             data: {
    //                 chatId: context.params.chatId,
    //                 senderId: senderId,
    //             },
    //         };

    //         try {
    //             await admin.messaging().send(message);
    //             console.log(`Message notification sent to ${receiverId}`);
    //         } catch (error) {
    //             console.error("Error sending notification:", error);
    //         }

    //         return null;
    //     });

    // /// 🔔 Notify when a connection request is SENT
    // exports.notifyConnectionRequestSent = functions.firestore
    //     .document("connection_requests/{requestId}")
    //     .onCreate(async(snap, context) => {
    //         const requestData = snap.data();
    //         const { senderUID, receiverUID } = requestData;

    //         // Get receiver’s FCM token
    //         const receiverDoc = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(receiverUID)
    //             .get();
    //         if (!receiverDoc.exists) return null;
    //         const fcmToken = receiverDoc.data().fcmToken;
    //         if (!fcmToken) return null;

    //         // Get sender’s name
    //         const senderDoc = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(senderUID)
    //             .get();
    //         const senderName = senderDoc.exists ?
    //             senderDoc.data().name || "Someone" :
    //             "Someone";

    //         const message = {
    //             token: fcmToken,
    //             notification: {
    //                 title: "🤝 New Connection Request",
    //                 body: `${senderName} sent you a connection request.`,
    //             },
    //             data: {
    //                 senderUID,
    //                 requestId: context.params.requestId,
    //             },
    //         };

    //         try {
    //             await admin.messaging().send(message);
    //             console.log("Connection request notification sent to:", receiverUID);
    //         } catch (error) {
    //             console.error("Error sending connection request notification:", error);
    //         }

    //         return null;
    //     });

    // /// 🔔 Notify when a connection request is ACCEPTED
    // exports.notifyConnectionRequestAccepted = functions.firestore
    //     .document("connection_requests/{requestId}")
    //     .onUpdate(async(change, context) => {
    //         const beforeData = change.before.data();
    //         const afterData = change.after.data();

    //         // Trigger only when status changes to "accepted"
    //         if (
    //             beforeData.status === afterData.status ||
    //             afterData.status !== "accepted"
    //         ) {
    //             return null;
    //         }

    //         const { senderUID, receiverUID } = afterData;

    //         // Get sender’s FCM token
    //         const senderDoc = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(senderUID)
    //             .get();
    //         if (!senderDoc.exists) return null;
    //         const fcmToken = senderDoc.data().fcmToken;
    //         if (!fcmToken) return null;

    //         // Get receiver’s name (the one who accepted)
    //         const receiverDoc = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(receiverUID)
    //             .get();
    //         const receiverName = receiverDoc.exists ?
    //             receiverDoc.data().name || "Someone" :
    //             "Someone";

    //         const message = {
    //             token: fcmToken,
    //             notification: {
    //                 title: "✅ Connection Accepted",
    //                 body: `${receiverName} accepted your connection request.`,
    //             },
    //             data: {
    //                 receiverUID,
    //                 requestId: context.params.requestId,
    //             },
    //         };

    //         try {
    //             await admin.messaging().send(message);
    //             console.log("Connection accepted notification sent to:", senderUID);
    //         } catch (error) {
    //             console.error("Error sending connection accepted notification:", error);
    //         }

    //         return null;
    //     });

    // /// 🔔 Notify when a connection request is REJECTED
    // exports.notifyConnectionRequestRejected = functions.firestore
    //     .document("connection_requests/{requestId}")
    //     .onDelete(async(snap, context) => {
    //         const requestData = snap.data();
    //         if (!requestData) return null;

    //         const { senderUID, receiverUID } = requestData;

    //         // Get sender’s FCM token (the one who sent request)
    //         const senderDoc = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(senderUID)
    //             .get();
    //         if (!senderDoc.exists) return null;
    //         const fcmToken = senderDoc.data().fcmToken;
    //         if (!fcmToken) return null;

    //         // Get receiver’s name (the one who rejected)
    //         const receiverDoc = await admin
    //             .firestore()
    //             .collection("users")
    //             .doc(receiverUID)
    //             .get();
    //         const receiverName = receiverDoc.exists ?
    //             receiverDoc.data().name || "Someone" :
    //             "Someone";

    //         const message = {
    //             token: fcmToken,
    //             notification: {
    //                 title: "❌ Connection Rejected",
    //                 body: `${receiverName} rejected your connection request.`,
    //             },
    //             data: {
    //                 receiverUID,
    //                 requestId: context.params.requestId,
    //             },
    //         };

    //         try {
    //             await admin.messaging().send(message);
    //             console.log("Connection rejected notification sent to:", senderUID);
    //         } catch (error) {
    //             console.error("Error sending connection rejected notification:", error);
    //         }

    //         return null;
    //     });

    const functions = require("firebase-functions");
    const admin = require("firebase-admin");
    admin.initializeApp();

    /// ✅ Certificate Status Change Notifications
    exports.notifyCertificateStatusChange = functions.firestore
        .document("certificates/{userId}/certificates/{certificateId}")
        .onWrite(async(change, context) => {
            const { userId } = context.params;

            const fcmTokenSnap = await admin
                .firestore()
                .collection("users")
                .doc(userId)
                .get();
            if (!fcmTokenSnap.exists) return null;

            const fcmToken = fcmTokenSnap.data().fcmToken;
            if (!fcmToken) return null;

            // Document DELETED → Disapproved
            if (!change.after.exists) {
                const message = {
                    token: fcmToken,
                    notification: {
                        title: "❌ Certificate Disapproved",
                        body: "Your certificate has been disapproved and removed.",
                    },
                };
                await admin.messaging().send(message);
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
                        body: "Your certificate has been approved.",
                    },
                };
                await admin.messaging().send(message);
            }

            return null;
        });

    /// ✅ Chat Message Notifications
    exports.notifyNewMessage = functions.firestore
        .document("chats/{chatId}/messages/{messageId}")
        .onCreate(async(snap, context) => {
            const messageData = snap.data();
            const { senderId, receiverId, text } = messageData;

            const receiverDoc = await admin
                .firestore()
                .collection("users")
                .doc(receiverId)
                .get();
            if (!receiverDoc.exists) return null;
            const fcmToken = receiverDoc.data().fcmToken;
            if (!fcmToken) return null;

            const senderDoc = await admin
                .firestore()
                .collection("users")
                .doc(senderId)
                .get();
            const senderName = senderDoc.exists ?
                senderDoc.data().name || "Someone" :
                "Someone";

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

            await admin.messaging().send(message);
            return null;
        });

    /// ✅ Connection Request Sent
    exports.notifyConnectionRequestSent = functions.firestore
        .document("connection_requests/{requestId}")
        .onCreate(async(snap, context) => {
            const requestData = snap.data();
            const { senderUID, receiverUID } = requestData;

            const receiverDoc = await admin
                .firestore()
                .collection("users")
                .doc(receiverUID)
                .get();
            if (!receiverDoc.exists) return null;
            const fcmToken = receiverDoc.data().fcmToken;
            if (!fcmToken) return null;

            const senderDoc = await admin
                .firestore()
                .collection("users")
                .doc(senderUID)
                .get();
            const senderName = senderDoc.exists ?
                senderDoc.data().name || "Someone" :
                "Someone";

            const message = {
                token: fcmToken,
                notification: {
                    title: "🤝 New Connection Request",
                    body: `${senderName} sent you a connection request.`,
                },
                data: {
                    senderUID,
                    requestId: context.params.requestId,
                },
            };

            await admin.messaging().send(message);
            return null;
        });

    /// ✅ Connection Request Accepted
    exports.notifyConnectionRequestAccepted = functions.firestore
        .document("connection_requests/{requestId}")
        .onUpdate(async(change, context) => {
            const beforeData = change.before.data();
            const afterData = change.after.data();
            if (
                beforeData.status === afterData.status ||
                afterData.status !== "accepted"
            ) {
                return null;
            }

            const { senderUID, receiverUID } = afterData;

            const senderDoc = await admin
                .firestore()
                .collection("users")
                .doc(senderUID)
                .get();
            if (!senderDoc.exists) return null;
            const fcmToken = senderDoc.data().fcmToken;
            if (!fcmToken) return null;

            const receiverDoc = await admin
                .firestore()
                .collection("users")
                .doc(receiverUID)
                .get();
            const receiverName = receiverDoc.exists ?
                receiverDoc.data().name || "Someone" :
                "Someone";

            const message = {
                token: fcmToken,
                notification: {
                    title: "✅ Connection Accepted",
                    body: `${receiverName} accepted your connection request.`,
                },
                data: {
                    receiverUID,
                    requestId: context.params.requestId,
                },
            };

            await admin.messaging().send(message);
            return null;
        });

    /// ✅ Connection Request Rejected
    exports.notifyConnectionRequestRejected = functions.firestore
        .document("connection_requests/{requestId}")
        .onDelete(async(snap, context) => {
            const requestData = snap.data();
            if (!requestData) return null;

            const { senderUID, receiverUID } = requestData;

            const senderDoc = await admin
                .firestore()
                .collection("users")
                .doc(senderUID)
                .get();
            if (!senderDoc.exists) return null;
            const fcmToken = senderDoc.data().fcmToken;
            if (!fcmToken) return null;

            const receiverDoc = await admin
                .firestore()
                .collection("users")
                .doc(receiverUID)
                .get();
            const receiverName = receiverDoc.exists ?
                receiverDoc.data().name || "Someone" :
                "Someone";

            const message = {
                token: fcmToken,
                notification: {
                    title: "❌ Connection Rejected",
                    body: `${receiverName} rejected your connection request.`,
                },
                data: {
                    receiverUID,
                    requestId: context.params.requestId,
                },
            };

            await admin.messaging().send(message);
            return null;
        });

    /// ✅ NEW → Post Like Notification
    exports.notifyPostLike = functions.firestore
        .document("posts/{postId}/likes/{userId}")
        .onCreate(async(snap, context) => {
            const { postId, userId } = context.params;
            const likeData = snap.data();

            const postDoc = await admin.firestore().collection("posts").doc(postId).get();
            if (!postDoc.exists) return null;

            const postOwnerId = postDoc.data().uid;
            if (postOwnerId === userId) return null; // don’t notify self

            const ownerDoc = await admin.firestore().collection("users").doc(postOwnerId).get();
            if (!ownerDoc.exists) return null;
            const ownerFcm = ownerDoc.data().fcmToken;
            if (!ownerFcm) return null;

            const message = {
                token: ownerFcm,
                notification: {
                    title: `${likeData.username} liked your post`,
                    body: "Tap to view",
                    image: likeData.userAvatar,
                },
                data: {
                    postId,
                    actorId: userId,
                },
            };

            await admin.messaging().send(message);
            return null;
        });

    /// ✅ NEW → Post Comment Notification
    exports.notifyPostComment = functions.firestore
        .document("posts/{postId}/comments/{commentId}")
        .onCreate(async(snap, context) => {
            const { postId } = context.params;
            const commentData = snap.data();

            const postDoc = await admin.firestore().collection("posts").doc(postId).get();
            if (!postDoc.exists) return null;

            const postOwnerId = postDoc.data().uid;
            if (postOwnerId === commentData.uid) return null; // don’t notify self

            const ownerDoc = await admin.firestore().collection("users").doc(postOwnerId).get();
            if (!ownerDoc.exists) return null;
            const ownerFcm = ownerDoc.data().fcmToken;
            if (!ownerFcm) return null;

            const message = {
                token: ownerFcm,
                notification: {
                    title: `${commentData.username} commented on your post`,
                    body: commentData.text,
                    image: commentData.userAvatar,
                },
                data: {
                    postId,
                    actorId: commentData.uid,
                },
            };

            await admin.messaging().send(message);
            return null;
        });