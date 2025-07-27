//  importing the files
import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/Login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sport_ignite/pages/home.dart';
import 'package:sport_ignite/pages/veiwAthletes.dart';
import 'firebase_options.dart';

void main() async {

  //  using firebase
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

  // this method is used to check whether the user is login
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
      // home:_isLogin ?
      //   Scaffold(
      //   body: Home(),
      // ):Login()
      home:Login (),

    );
  } 
}