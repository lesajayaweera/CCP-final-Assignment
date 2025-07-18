import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/Login.dart';
import 'package:sport_ignite/pages/home.dart';
import 'package:sport_ignite/widget/common/post_create.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generated by flutterfire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  bool _isLogin = false;
  int selectedIndex = 0;


  void _Login(){
    setState(() {
      _isLogin = true;

    });
  }
  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home:_isLogin ?
        Scaffold(
        body: Home(),
      ):Login()
    );
  } 
}