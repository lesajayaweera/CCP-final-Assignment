import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sport_ignite/Services/LocalNotifications.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _messaging.requestPermission();

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.showNotification(message);
    });

    // Background/terminated tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // You can handle redirection or data here
      print('Notification tapped: ${message.notification?.title}');
    });

    // Optionally get the token
    String? token = await _messaging.getToken();
    print("FCM Token: $token");
  }
}
