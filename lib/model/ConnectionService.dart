import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';

class ConnectionService {
  //  this class is responsible for create and manage connections with the user including the athlete and the sponsor

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> sendConnectionRequestUsingUID(
    BuildContext context, String receiverUID) async {
  final String senderUID = FirebaseAuth.instance.currentUser?.uid ?? '';
  if (senderUID.isNotEmpty && receiverUID.isNotEmpty) {
    
    // Check if request has already been sent
    if (await hasSentRequest(senderUID, receiverUID) == false) {
      // Store the request in receiver's subcollection
      await _firestore
          .collection('users')
          .doc(receiverUID)
          .collection('connection_requests')
          .doc(senderUID)
          .set({
        'senderUID': senderUID,
        'receiverUID': receiverUID,
        'status': 'pending', // can be: pending, accepted, rejected
        'timestamp': FieldValue.serverTimestamp(),
      });

      showSnackBar(context, 'Connection request sent', Colors.green);
    } else {
      showSnackBar(context, 'Connection request already sent', Colors.orange);
    }
  } else {
    showSnackBar(context, 'User not logged in', Colors.red);
  }
}


  /// Check if a connection request has been sent (pending)
  static Future<bool> hasSentRequest(String myUid, String toUid) async {
    final doc = await _firestore
        .collection('users')
        .doc(toUid)
        .collection('connection_requests')
        .doc(myUid)
        .get();

    return doc.exists;
  }
}
