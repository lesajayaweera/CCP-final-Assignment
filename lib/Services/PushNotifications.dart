import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_ignite/Services/LocalNotifications.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _messaging.requestPermission();

    // Get the FCM token
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    
    await _saveTokenToFirestore(token);

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      print("Token refreshed: $newToken");
      await _saveTokenToFirestore(newToken);
    });

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.showNotification(message);
    });

    // Background/terminated tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notification tapped: ${message.notification?.title}');
    });
  }

  static Future<void> _saveTokenToFirestore(String? token) async {
    if (token == null) return;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDoc.set(
        {
          'fcmToken': token,
        },
        SetOptions(merge: true),
      );
    }
  }
}
