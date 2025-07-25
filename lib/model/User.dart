import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/pages/home.dart';
 class Users {

 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> Login(BuildContext context, String email, String password) async {
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
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        // Step 3: Navigate to the correct page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SocialFeedScreen(role: role)),
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
