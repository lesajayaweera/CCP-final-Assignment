import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/pages/home.dart';

class Athlete {
  late String sport;
  late int experience;
  late String institute;
  late String gender;

  late File? profile;
  late String name;
  late String email;
  late String pass;
  late String tel;
  late String role;
  late String province;
  late String city;
  late String date;

  Athlete(
    this.name,
    this.email,
    this.role,
    this.pass,
    this.tel,
    this.city,
    this.province,
    this.date,
    this.sport,
    this.experience,
    this.institute,
    this.gender,
    this.profile,
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> Register(BuildContext context) async {
    try {
      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      final User? user = userCredentials.user;

      if (await writeData(context)) {
        showSnackBar(context, "Athlete Sucessfully Registered", Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SocialFeedScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString(), Colors.red);
    }
  }

  Future<bool> writeData(BuildContext context) async {
    String image = profile != null ? await convertImageToBase64(profile!) : '';
    print('image : ' + image);
    try {
      await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
        "name": name,
        "email": email,
        "role": role,
        "tel": tel,
        "province": province,
        "city": city,
        "date": date,
        "sport": sport,
        "experience": experience,
        "institute": institute,
        "gender": gender,
        'profile': image,
      });
      return true;
    } on FirebaseException catch (e) {
      showSnackBar(context, "Database Error !", Colors.red);
      return false;
    }
  }

//   @override
//   void Login(BuildContext context, String email, String password) async {
   
// }
}
