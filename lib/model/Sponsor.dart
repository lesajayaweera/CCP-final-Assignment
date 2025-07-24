import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/pages/home.dart';

class Sponsor{
  late String companyname;
  late String intrestedSport;
  late String orgSector;

  late String name;
  late String email;
  late String pass;
  late String tel;
  late String role;
  late String province;
  late String city;
  late String date;
  late File? profile;


  Sponsor(
    this.name,
    this.email,
    this.role,
    this.pass,
    this.tel,
    this.city,
    this.province,
    this.date,
    this.companyname,
    this.intrestedSport,
    this.orgSector,
    this.profile,

  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> Register(BuildContext context) async {
    showLoadingDialog(context);
    try {
      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      final User? user = userCredentials.user;

      if (await writeData(context)) {
        showSnackBar(context, "Athlete Sucessfully Registered", Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SocialFeedScreen(role: this.role,)),
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString(), Colors.red);
    }
  }

  Future<bool> writeData(BuildContext context) async {
  try {
    String? imageUrl;

    // Step 1: Upload image if it exists
    if (profile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${_auth.currentUser!.uid}.jpg');

      // Upload image
      await storageRef.putFile(profile!);

      // Step 2: Get the download URL
      imageUrl = await storageRef.getDownloadURL();
    }

    // Step 3: Save user data in Firestore
    await _firestore.collection('sponsors').doc(_auth.currentUser?.uid).set({
      "name": name,
      "email": email,
      "role": role,
      "tel": tel,
      "province": province,
      "city": city,
      "date": date,
      "sportIntrested": intrestedSport,
      "company": companyname,
      "orgStructure": orgSector,
      "gender": gender,
      'profile': imageUrl ?? '', // Save image URL or empty string
    });

    return true;
  } on FirebaseException catch (e) {
    showSnackBar(context, "Database Error: ${e.message}", Colors.red);
    return false;
  }
}


  
  void Login(BuildContext context) {
    // TODO: implement Login
  }
}
