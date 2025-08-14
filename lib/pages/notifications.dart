import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void dispose() {
    _markAllNotificationsAsRead(); // Marks as read when navigating away
    super.dispose();
  }

  Future<void> _markAllNotificationsAsRead() async {
    if (userId == null) return;

    final notifCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications');

    final snapshot = await notifCollection.where('isRead', isEqualTo: 'false').get();

    for (final doc in snapshot.docs) {
      await doc.reference.update({'isRead': 'true'});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('You must be logged in')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading notifications.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          // Filter out read notifications
          final unreadDocs = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['isRead'] == 'false';
          }).toList();

          if (unreadDocs.isEmpty) {
            return const Center(child: Text("No unread notifications."));
          }

          final notifications = unreadDocs.map((doc) {
            return NotificationItem.fromFirestore(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationCard(notification: notifications[index]);
            },
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.notifications, color: Colors.blue.shade800),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        notification.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification.timestamp.toLocal().toString().split('.')[0],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String message;
  final String type;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem({
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  factory NotificationItem.fromFirestore(Map<String, dynamic> data) {
    return NotificationItem(
      message: data['message'] ?? '',
      type: data['type'] ?? 'info',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] == 'true',
    );
  }
}
