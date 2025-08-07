import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      profileImage:
          'https://images.unsplash.com/photo-1494790108755-2616b332c5cd?w=150',
      name: 'Natalia Shostak',
      additionalCount: '2,486 others',
      action: 'reacted to your post',
      time: '1m',
      message:
          'This is very wonderful news. I\'m looking forward to November...',
      additionalInfo:
          'In November, we are launching an internship program for UI/UX designers with ...',
      reactions: '2,487',
      comments: '275',
    ),
    NotificationItem(
      profileImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      name: 'Samson Kennedy',
      additionalCount: '2,486 others',
      action: 'reacted to your post',
      time: '10m',
      message:
          'This is very wonderful news. I\'m looking forward to November...',
      reactions: '2,487',
      comments: '275',
    ),
    NotificationItem(
      profileImage:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      name: 'Andrea Baker',
      additionalCount: '2,486 others',
      action: 'reacted to your post',
      time: '56m',
      message:
          'This is very wonderful news. I\'m looking forward to November...',
      reactions: '2,487',
      comments: '275',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'), centerTitle: true),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(notification: notifications[index]);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'See notification you missed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({Key? key, required this.notification})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Images Stack
          Container(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(notification.profileImage),
                ),
                // Reaction emoji overlay
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Text('❤️', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name, action, and time
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: notification.name,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextSpan(
                              text: notification.additionalCount,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: ' ${notification.action}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      notification.time,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                // Message content
                Text(
                  notification.message,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                if (notification.additionalInfo != null) ...[
                  SizedBox(height: 4),
                  Text(
                    notification.additionalInfo!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
                SizedBox(height: 8),
                // Stats
                Row(
                  children: [
                    Text(
                      '${notification.reactions} Reactions',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    Text(
                      ' • ',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    Text(
                      '${notification.comments} Comments',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String profileImage;
  final String name;
  final String additionalCount;
  final String action;
  final String time;
  final String message;
  final String? additionalInfo;
  final String reactions;
  final String comments;

  NotificationItem({
    required this.profileImage,
    required this.name,
    required this.additionalCount,
    required this.action,
    required this.time,
    required this.message,
    this.additionalInfo,
    required this.reactions,
    required this.comments,
  });
}
