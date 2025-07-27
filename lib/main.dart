//  importing the files
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sport_ignite/pages/Login.dart';

import 'firebase_options.dart';

void main() async {
  //  using firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      title: 'Sport Ignite',
      home: const Login(), // Show login screen first
    );
  }
}

