
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sport_ignite/Services/LocalNotifications.dart';
import 'package:sport_ignite/Services/PushNotifications.dart';
import 'package:sport_ignite/widget/AthWrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize notifications
  LocalNotificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sport Ignite',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const AuthWrapper(),
    );
  }
}

