import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';

class ConnectionService {
  //  this class is responsible for create and manage connections with the user including the athlete and the sponsor

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> sendConnectionRequestUsingUID(
    BuildContext context,
    String receiverUID,
  ) async {
    final String senderUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (senderUID.isNotEmpty && receiverUID.isNotEmpty) {
      if (await hasSentRequest(senderUID, receiverUID) == false) {
        await _firestore.collection('connection_requests').add({
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
    final querySnapshot = await _firestore
        .collection('connection_requests')
        .where('senderUID', isEqualTo: myUid)
        .where('receiverUID', isEqualTo: toUid)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  static Stream<QuerySnapshot> getPendingInvitations() {
    final String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (myUid.isEmpty) {
      return const Stream.empty(); // no logged in user
    }

    return _firestore
        .collection('connection_requests')
        .where('receiverUID', isEqualTo: myUid)
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
