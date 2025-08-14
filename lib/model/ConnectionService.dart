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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('Connection Request Sent'),
              ],
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF10B981),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        // showSnackBar(context, 'Connection request already sent', Colors.orange);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('Connection request already sent'),
              ],
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color.fromARGB(255, 185, 123, 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
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

  static Stream<int> pendingRequestsCountStream() {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('connection_requests')
        .where('receiverUID', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  static Future<void> acceptConnectionRequest(
    String requestId,
    String senderUID,
    
  ) async {

    final String receiverUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('Receiver UID: $receiverUID');
    final WriteBatch batch = _firestore.batch();

    // 1. Update the request status to 'accepted'
    final requestRef = _firestore
        .collection('connection_requests')
        .doc(requestId);
    batch.update(requestRef, {'status': 'accepted'});

    // 2. Add receiver to sender's "connections" subcollection
    final senderConnectionRef = _firestore
        .collection('users')
        .doc(senderUID)
        .collection('connections')
        .doc(receiverUID);
    batch.set(senderConnectionRef, {
      'uid': receiverUID,
      'connectedAt': FieldValue.serverTimestamp(),
    });

    // 3. Add sender to receiver's "connections" subcollection
    final receiverConnectionRef = _firestore
        .collection('users')
        .doc(receiverUID)
        .collection('connections')
        .doc(senderUID);
    batch.set(receiverConnectionRef, {
      'uid': senderUID,
      'connectedAt': FieldValue.serverTimestamp(),
    });

    // 4. Commit all in a single batch
    await batch.commit();
  }


  static Future<void> rejectConnectionRequest(
    BuildContext context,
    String senderUID,
    
  ) async {

    final String receiverUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('Receiver UID: $receiverUID');
  try {
    final querySnapshot = await _firestore
        .collection('connection_requests')
        .where('senderUID', isEqualTo: senderUID)
        .where('receiverUID', isEqualTo: receiverUID)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the document ID and delete it
      await _firestore
          .collection('connection_requests')
          .doc(querySnapshot.docs.first.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.cancel, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Connection Request Rejected'),
            ],
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No connection request found'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
    }
  } catch (e) {
    print('Error rejecting request: $e');
  }
}

}
