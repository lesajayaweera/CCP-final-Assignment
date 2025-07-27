import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/pages/dashboard.dart';
import 'package:sport_ignite/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // login method

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
        // ✅ Save UID to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);

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
              builder: (context) => Dashboard(role: role),
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

  //  get the user profile image
  Future<String?> getUserProfileImage(String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance
          .collection(role.toString().toLowerCase())
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.data()?['profile'] as String?;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserDetails(
    BuildContext context,
    String role,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        showSnackBar(context, "User not logged in.", Colors.red);
        return null;
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(role.toLowerCase().trim())
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

  Future<Map<String, dynamic>?> getUserDetailsByUIDAndRole(BuildContext context,
    String uid,
    String role,
  ) async {
    try {
      // Determine the correct collection based on the role
      String collectionName;

      switch (role.toLowerCase()) {
        case 'athlete':
          collectionName = 'athletes';
          break;
        case 'sponsor':
          collectionName = 'sponsors';
          break;
        default:
          throw Exception("Invalid role: $role");
      }

      // Query the collection by UID
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        showSnackBar(context,'User not found',Colors.red);
        return null;
      }
    } catch (e) {
      showSnackBar(context,'Error fetching user details: $e',Colors.red);
      return null;
    }
  }
}
