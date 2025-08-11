// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:sport_ignite/pages/chatScreen.dart';

// class MessagingService {
//   final FirebaseFirestore _firebase = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   static void startNewChat(
//     BuildContext context,

//     String targetUserId,
//   ) async {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserId == null) {
//       // Handle user not logged in
//       return;
//     }

//     final chatId = getChatId(currentUserId, targetUserId);
//     final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

//     final doc = await chatRef.get();

//     if (!doc.exists) {
//       await chatRef.set({
//         'participants': [currentUserId, targetUserId],
//         'lastMessage': '',
//         'lastUpdated': FieldValue.serverTimestamp(),
//       });
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChatScreen(
//           chatId: chatId,
//           currentID: currentUserId,
//           targetID: targetUserId,
//         ),
//       ),
//     );
//   }

//   static String getChatId(String uid1, String uid2) {
//     final ids = [uid1, uid2]..sort(); // ensures uniqueness
//     return ids.join('_');
//   }

//   Stream<QuerySnapshot> getChatMessages(String chatId) {
//   return FirebaseFirestore.instance
//       .collection('chats')
//       .doc(chatId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true) // latest at top
//       .snapshots();
// }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/chatScreen.dart';

class MessagingService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static void startNewChat(BuildContext context, String targetUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    final chatId = getChatId(currentUserId, targetUserId);
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final doc = await chatRef.get();
    if (!doc.exists) {
      await chatRef.set({
        'participants': [currentUserId, targetUserId],
        'lastMessage': '',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chatId,
          currentID: currentUserId,
          targetID: targetUserId,
        ),
      ),
    );
  }

  static String getChatId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return ids.join('_');
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firebase
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String chatId, String text) async {
    final senderId = _auth.currentUser?.uid;
    if (senderId == null) return;

    final messageData = {
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    };

    await _firebase
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    await _firebase.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getUserChatsWithDetails() {
    final currentUid = _auth.currentUser?.uid;
    if (currentUid == null) {
      return const Stream.empty();
    }

    // Modified approach: Remove orderBy from the initial query
    // and sort in memory instead
    return _firebase
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> chats = [];

          for (var doc in snapshot.docs) {
            final participants = List<String>.from(doc['participants']);
            final otherUserId = participants.firstWhere(
              (id) => id != currentUid,
            );

            try {
              // Step 1: Get the user's role from "users" collection
              final userDoc = await _firebase
                  .collection('users')
                  .doc(otherUserId)
                  .get();

              if (!userDoc.exists) {
                print('User document not found for ID: $otherUserId');
                continue; // Skip this chat if user doesn't exist
              }

              final role = userDoc.data()?['role'] ?? 'Unknown';

              // Step 2: Get details from the role-specific collection
              final roleCollection = role
                  .toLowerCase(); // "athlete" or "sponsor"
              final roleDoc = await _firebase
                  .collection(roleCollection)
                  .doc(otherUserId)
                  .get();

              // Add null checks and default values
              final chatData = {
                'chatId': doc.id,
                'lastMessage': doc.data()['lastMessage'] ?? 'No messages yet',
                'lastUpdated': doc.data()['lastUpdated'] ?? Timestamp.now(),
                'participants': participants,
                'otherUserId': otherUserId,
                'role': role,
                'otherUserName': roleDoc.exists
                    ? (roleDoc.data()?['name'] ?? 'Unknown User')
                    : 'Unknown User',
                'otherUserProfilePic': roleDoc.exists
                    ? (roleDoc.data()?['profile'] ?? '')
                    : '',
                'otherUserEmail': roleDoc.exists
                    ? (roleDoc.data()?['email'] ?? '')
                    : '',
                'otherUserTel': roleDoc.exists
                    ? (roleDoc.data()?['tel'] ?? '')
                    : '',
              };

              chats.add(chatData);
            } catch (e) {
              print('Error processing chat ${doc.id}: $e');
              // Continue processing other chats even if one fails
            }
          }

          // Sort the chats by lastUpdated in memory (most recent first)
          chats.sort((a, b) {
            final aTime = a['lastUpdated'] as Timestamp;
            final bTime = b['lastUpdated'] as Timestamp;
            return bTime.compareTo(aTime); // Descending order
          });

          return chats;
        });
  }

  // Alternative approach: Use a different query structure
  Stream<List<Map<String, dynamic>>> getUserChatsWithDetailsAlternative() {
    final currentUid = _auth.currentUser?.uid;
    if (currentUid == null) {
      return const Stream.empty();
    }

    // This approach uses a simpler query and handles sorting differently
    return _firebase
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .limit(50) // Add a reasonable limit to improve performance
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> chats = [];

          // Create a list of futures to process all chats concurrently
          final futures = snapshot.docs.map((doc) async {
            try {
              final participants = List<String>.from(doc['participants']);
              final otherUserId = participants.firstWhere(
                (id) => id != currentUid,
              );

              // Use Future.wait to run both queries concurrently
              final results = await Future.wait([
                _firebase.collection('users').doc(otherUserId).get(),
              ]);

              final userDoc = results[0];
              if (!userDoc.exists) {
                return null; // Skip this chat
              }

              final role = userDoc.data()?['role'] ?? 'Unknown';
              final roleCollection = role.toLowerCase();

              final roleDoc = await _firebase
                  .collection(roleCollection)
                  .doc(otherUserId)
                  .get();

              return {
                'chatId': doc.id,
                'lastMessage': doc.data()['lastMessage'] ?? 'No messages yet',
                'lastUpdated': doc.data()['lastUpdated'] ?? Timestamp.now(),
                'participants': participants,
                'otherUserId': otherUserId,
                'role': role,
                'otherUserName': roleDoc.exists
                    ? (roleDoc.data()?['name'] ?? 'Unknown User')
                    : 'Unknown User',
                'otherUserProfilePic': roleDoc.exists
                    ? (roleDoc.data()?['profile'] ?? '')
                    : '',
                'otherUserEmail': roleDoc.exists
                    ? (roleDoc.data()?['email'] ?? '')
                    : '',
                'otherUserTel': roleDoc.exists
                    ? (roleDoc.data()?['tel'] ?? '')
                    : '',
              };
            } catch (e) {
              print('Error processing chat ${doc.id}: $e');
              return null;
            }
          }).toList();

          // Wait for all futures to complete and filter out null results
          final results = await Future.wait(futures);
          chats = results
              .where((chat) => chat != null)
              .cast<Map<String, dynamic>>()
              .toList();

          // Sort by lastUpdated (most recent first)
          chats.sort((a, b) {
            final aTime = a['lastUpdated'] as Timestamp;
            final bTime = b['lastUpdated'] as Timestamp;
            return bTime.compareTo(aTime);
          });

          return chats;
        });
  }
}
