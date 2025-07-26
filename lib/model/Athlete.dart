import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/CertificateInput.dart';
import 'package:sport_ignite/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Step 3: Save user data in Firestore
      await _firestore.collection('athlete').doc(_auth.currentUser?.uid).set({
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
        'profile': imageUrl ?? '', // Save image URL or empty string
      });

      return true;
    } on FirebaseException catch (e) {
      showSnackBar(context, "Database Error: ${e.message}", Colors.red);
      return false;
    }
  }

  // Get the Athlete data

  static Future<Map<String, dynamic>?> getAthleteDetails(
    BuildContext context,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        showSnackBar(context, "User not logged in.", Colors.red);
        return null;
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('athlete')
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        showSnackBar(
          context,
          "No athlete data found for this user.",
          Colors.red,
        );
        return null;
      }
    } on FirebaseException catch (e) {
      showSnackBar(
        context,
        "Error fetching athlete data: ${e.message}",
        Colors.red,
      );
      return null;
    }
  }

  // Add certificate

  static Future<void> uploadCertificates(
    BuildContext context,
    List<CertificateInput> certificateInputs,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("User not logged in.")),
      // );
      showSnackBar(context, "User not logged in.", Colors.red);
      return;
    }

    for (int i = 0; i < certificateInputs.length; i++) {
      final cert = certificateInputs[i];

      // Skip if incomplete
      if (cert.title.isEmpty ||
          cert.issuer.isEmpty ||
          cert.certificateImage == null ||
          cert.referenceLetterImage == null) {
        continue;
      }

      try {
        // Upload certificate image
        final String certPath =
            'certificates/$uid/${DateTime.now().millisecondsSinceEpoch}_cert_$i.jpg';
        final certRef = FirebaseStorage.instance.ref(certPath);
        final certUpload = await certRef.putData(cert.certificateImage!);
        final String certUrl = await certUpload.ref.getDownloadURL();

        // Upload reference letter image
        final String refPath =
            'certificates/$uid/${DateTime.now().millisecondsSinceEpoch}_ref_$i.jpg';
        final refRef = FirebaseStorage.instance.ref(refPath);
        final refUpload = await refRef.putData(cert.referenceLetterImage!);
        final String refUrl = await refUpload.ref.getDownloadURL();

        // Save metadata to Firestore
        await FirebaseFirestore.instance
            .collection('certificates')
            .doc(uid)
            .collection('certificates')
            .add({
              'title': cert.title,
              'issuedBy': cert.issuer,
              'certificateImageUrl': certUrl,
              'referenceLetterImageUrl': refUrl,
              'createdAt': FieldValue.serverTimestamp(),
              'status': 'false',
            });
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Failed to upload certificate ${i + 1}")),
        // );
        showSnackBar(
          context,
          "Failed to upload certificate ${i + 1}",
          Colors.red,
        );
      }
    }

    showSnackBar(context, "✅ Certificates uploaded successfully", Colors.green);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("✅ Certificates uploaded successfully")),
    // );
  }

  static Future<List<Map<String, dynamic>>> getApprovedCertificates() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    throw Exception("User not logged in.");
  }

  final querySnapshot = await FirebaseFirestore.instance
      .collection('certificates')
      .doc(uid)
      .collection('certificates')
      .where('status', isEqualTo: "true") // or 'true' if your field is a string
      .get();

  return querySnapshot.docs.map((doc) => doc.data()).toList();
}

}
