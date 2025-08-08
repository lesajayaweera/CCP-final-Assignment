import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/pages/manageInvititations.dart';

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

  static Future<List<InvitationRequest>> getEnrichedInvitations() async {
    final String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (myUid.isEmpty) return [];

    final snapshot = await _firestore
        .collection('connection_requests')
        .where('receiverUID', isEqualTo: myUid)
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .get();

    List<InvitationRequest> invitations = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final senderUID = data['senderUID'];
      final timestamp = data['timestamp'] as Timestamp;

      // Try fetching from sponsor
      DocumentSnapshot userDoc = await _firestore
          .collection('sponsor')
          .doc(senderUID)
          .get();

      String name = "";
      String title = "";
      String profileImage = "";
      String role = "";

      if (userDoc.exists) {
        final user = userDoc.data() as Map<String, dynamic>;
        name = user['name'];
        title = '${user['sportIntrested']} Sponsor';
        profileImage = user['profile'];
        role = 'Sponsor';
      } else {
        // Try athlete
        userDoc = await _firestore.collection('athlete').doc(senderUID).get();
        if (userDoc.exists) {
          final user = userDoc.data() as Map<String, dynamic>;
          name = user['name'];
          title = '${user['sport']} Athlete';
          profileImage = user['profile'];
          role = 'Athlete';
        }
      }

      final invitation = InvitationRequest(
        id: doc.id,
        profileImage: profileImage,
        name: name,
        title: title,
        mutualConnections: 0, // You can implement this later
        timeAgo: _formatTimestamp(timestamp),
        message: null, // Optional: add this if you have a message field
      );

      invitations.add(invitation);
    }

    return invitations;
  }

  static String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp.toDate());

    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
