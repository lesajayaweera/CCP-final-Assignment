import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/Services/PushNotifications.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/CertificateInput.dart';
import 'package:sport_ignite/pages/dashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Athlete {
  late String sport;
  late int experience;
  late String institute;
  late String gender;

  late String fullName;

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
    this.fullName,
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> Register(BuildContext context) async {
    showLoadingDialog(context); // Show loading spinner

    try {
      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);

      final User? user = userCredentials.user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);

        if (await writeData(context)) {
          PushNotificationService.initialize();

          Navigator.pop(context);

          showSnackBar(
            context,
            "Athlete Successfully Registered",
            Colors.green,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard(role: role)),
          );

          return;
        }
      }

      Navigator.pop(context);
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

      if (profile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${_auth.currentUser!.uid}.jpg');

        await storageRef.putFile(profile!);

        imageUrl = await storageRef.getDownloadURL();
      }

      await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
        "name": name,
        "email": email,
        "role": role,
        "tel": tel,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('athlete').doc(_auth.currentUser?.uid).set({
        "name": name,
        "email": email,
        "role": role,
        "tel": tel,
        "fullName": fullName,

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
        showSnackBar(
          context,
          "Failed to upload certificate ${i + 1}",
          Colors.red,
        );
      }
    }

    showSnackBar(context, "✅ Certificates uploaded successfully", Colors.green);
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
        .where(
          'status',
          isEqualTo: "true",
        ) // or 'true' if your field is a string
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<List<Map<String, dynamic>>> getApprovedCertificatesBYuid(
    String uid,
  ) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('certificates')
        .doc(uid)
        .collection('certificates')
        .where(
          'status',
          isEqualTo: "true",
        ) // or 'true' if your field is a string
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<List<String>> getAllSponsorUIDs(
    
  ) async {

    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    try {
      // 1. Get all sponsors
      QuerySnapshot sponsorSnapshot = await FirebaseFirestore.instance
          .collection('sponsor')
          .get();
      List<String> allSponsorUIDs = sponsorSnapshot.docs
          .map((doc) => doc.id)
          .toList();

      // 2. Get all connection requests sent by the current user
      QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('connection_requests')
          .where('senderUID', isEqualTo: currentUserUid)
          .get();
      List<String> requestedUIDs = requestSnapshot.docs
          .map((doc) => doc['receiverUID'] as String)
          .toList();

      // 3. Get all connected users under the current user's connections subcollection
      QuerySnapshot connectionSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .collection('connections')
          .get();
      List<String> connectedUIDs = connectionSnapshot.docs
          .map((doc) => doc['uid'] as String)
          .toList();

      // 4. Exclude sponsors who are already connected or already requested
      List<String> availableUIDs = allSponsorUIDs.where((uid) {
        return !requestedUIDs.contains(uid) && !connectedUIDs.contains(uid);
      }).toList();

      return availableUIDs;
    } catch (e) {
      print('Error fetching available sponsors: $e');
      return [];
    }
  }

  // load the stats
  static Future<Map<String, dynamic>?> loadUserStats(
    String sport,
    String email,
  ) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('user_stats')
          .doc(sport)
          .collection('athletes')
          .doc(email)
          .get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      // You can log or handle the error if needed
      return null;
    }
  }

  // GET all athletes except the current user
  static Stream<List<Map<String, dynamic>>> getAllAthletesStream() {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid == null) {
      return Stream.value([]);
    }

    // Get current user's role
    final currentUserDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .snapshots();

    return currentUserDoc.asyncExpand((currentUserSnapshot) {
      if (!currentUserSnapshot.exists) {
        return Stream.value([]);
      }

      final currentUserData = currentUserSnapshot.data()!;
      final String currentUserRole = currentUserData['role'];

      // Only proceed if current user is an Athlete
      if (currentUserRole != "Athlete") {
        return Stream.value([]);
      }

      // Get all users with role = Athlete
      return FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Athlete')
          .snapshots()
          .asyncMap((userSnapshot) async {
            // --- 1. Get current user's connections ---
            final connectionsSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUserUid)
                .collection('connections')
                .get();

            final Set<String> excludedUserIds = connectionsSnapshot.docs
                .map((doc) => doc.id)
                .toSet();

            // --- 2. Get connection requests (pending + accepted) ---
            final requestsSnapshot = await FirebaseFirestore.instance
                .collection('connection_requests')
                .where('status', whereIn: ['pending', 'accepted'])
                .get();

            for (final doc in requestsSnapshot.docs) {
              final data = doc.data();
              final sender = data['senderUID'] as String;
              final receiver = data['receiverUID'] as String;

              if (sender == currentUserUid) {
                excludedUserIds.add(receiver);
              }
              if (receiver == currentUserUid) {
                excludedUserIds.add(sender);
              }
            }

            // --- 3. Collect UIDs of athletes to show ---
            final List<String> validAthleteUids = userSnapshot.docs
                .where(
                  (doc) =>
                      doc.id != currentUserUid &&
                      !excludedUserIds.contains(doc.id),
                )
                .map((doc) => doc.id)
                .toList();

            if (validAthleteUids.isEmpty) {
              return [];
            }

            // --- 4. Fetch athlete details from athlete collection ---
            final athleteDocs = await FirebaseFirestore.instance
                .collection('athlete')
                .where(FieldPath.documentId, whereIn: validAthleteUids)
                .get();

            final List<Map<String, dynamic>> athletes = athleteDocs.docs
                .map((doc) => {'uid': doc.id, ...doc.data()})
                .toList();

            return athletes;
          });
    });
  }
}
