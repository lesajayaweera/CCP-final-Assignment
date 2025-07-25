import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart' hide gender;
import 'package:sport_ignite/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sponsor {
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
      // Step 1: Create user with Firebase Auth
      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);

      final User? user = userCredentials.user;

      if (user != null) {
        // ✅ Save UID to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);

        // Step 2: Write additional user data to Firestore (if implemented in writeData)
        if (await writeData(context)) {
          showSnackBar(
            context,
            "Sponsor Successfully Registered",
            Colors.green,
          );

          // Step 3: Navigate to the SocialFeedScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SocialFeedScreen(role: this.role),
            ),
          );
        }
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
      await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
        "name": name,
        "email": email,
        "role": role,
        "tel": tel,
        'createdAt':FieldValue.serverTimestamp()
      });
      // Step 3: Save user data in Firestore
      await _firestore.collection('sponsor').doc(_auth.currentUser?.uid).set({
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
        'profile': imageUrl ?? '', // Save image URL or empty string
      });

      return true;
    } on FirebaseException catch (e) {
      showSnackBar(context, "Database Error: ${e.message}", Colors.red);
      return false;
    }
  }

  Future<void> Login(
    BuildContext context,
    String email,
    String password,
  ) async {
    showLoadingDialog(context); // Show loading spinner

    try {
      // Step 1: Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Step 2: Fetch user role from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role'];

          // Step 3: Navigate to the correct page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SocialFeedScreen(role: role),
            ),
          );
        } else {
          showSnackBar(context, "User data not found", Colors.red);
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Login failed: ${e.message}", Colors.red);
    } catch (e) {
      showSnackBar(context, "Something went wrong: $e", Colors.red);
    }
  }
}
