import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/Services/PushNotifications.dart';
import 'package:sport_ignite/config/essentials.dart' hide gender;
import 'package:sport_ignite/pages/dashboard.dart';
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
    showLoadingDialog(context); // Show the loading spinner

    try {
      
      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);

      final User? user = userCredentials.user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);

        bool writeSuccess = await writeData(context);
         PushNotificationService.initialize();

        Navigator.pop(
          context,
        );

        if (writeSuccess) {
          showSnackBar(
            context,
            "Sponsor Successfully Registered",
            Colors.green,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard(role: role)),
          );
        } else {
          showSnackBar(context, "Failed to save user data.", Colors.red);
        }
      } else {
        Navigator.pop(context); 
        showSnackBar(
          context,
          "Registration failed. Please try again.",
          Colors.red,
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); 
      showSnackBar(context, e.message.toString(), Colors.red);
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(context, "Something went wrong: $e", Colors.red);
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
        'createdAt': FieldValue.serverTimestamp(),
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

  // to get the athletes who have verified certificates
  static Future<List<String>> getUidsWithApprovedCertificates() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collectionGroup('certificates')
        .where('status', isEqualTo: 'true')
        .get();

    // Extract UIDs from document references
    final Set<String> uniqueUids = {};

    for (var doc in querySnapshot.docs) {
      // doc.reference.parent.parent points to the UID document under 'certificates'
      final uid = doc.reference.parent.parent?.id;
      if (uid != null) {
        uniqueUids.add(uid);
      }
    }

    return uniqueUids.toList();
  }
  // GET all sponsors except the current user
static Stream<List<Map<String, dynamic>>> getAllSponsorsStream() {
  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  return FirebaseFirestore.instance
      .collection('sponsor')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .where((doc) => doc.id != currentUserUid) // exclude current user
            .map(
              (doc) => {
                'uid': doc.id,
                ...doc.data(),
              },
            )
            .toList(),
      );
}

}
