import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/chatScreen.dart';

class MessagingService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  static void startNewChat(
    BuildContext context,
    
    String targetUserId,
  ) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      // Handle user not logged in
      return;
    }

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
    final ids = [uid1, uid2]..sort(); // ensures uniqueness
    return ids.join('_');
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: true) // latest at top
      .snapshots();
}
}
