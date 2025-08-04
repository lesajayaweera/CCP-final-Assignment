import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // login method

  Future<bool> Login(
    BuildContext context,
    String email,
    String password,
  ) async {
    // showLoadingDialog(context); // Show the loading spinner

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);

        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        // Navigator.pop(context);

        if (userDoc.exists) {
          String role = userDoc['role'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard(role: role)),
          );

          return true;
        } else {
          showSnackBar(context, "User data not found", Colors.red);
          return false;
        }
      }

      // Navigator.pop(context); // fallback
      return false;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showSnackBar(context, "Login failed: ${e.message}", Colors.red);
      return false;
    } catch (e) {
      // Navigator.pop(context);
      showSnackBar(context, "Something went wrong: $e", Colors.red);
      return false;
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

  Future<Map<String, dynamic>?> getUserDetailsByUIDAndRole(
    BuildContext context,
    String uid,
    String role,
  ) async {
    try {
      String collectionName;

      switch (role.toLowerCase()) {
        case 'athlete':
          collectionName = 'athlete';
          break;
        case 'sponsor':
          collectionName = 'sponsor';
          break;
        default:
          throw Exception("Invalid role: $role");
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        showSnackBar(context, 'User not found', Colors.red);
        return null;
      }
    } catch (e) {
      showSnackBar(context, 'Error fetching user details: $e', Colors.red);
      return null;
    }
  }
}
