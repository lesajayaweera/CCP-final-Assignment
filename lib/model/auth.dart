import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/Sponsor.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/model/athlete.dart';

class Firebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final FirebaseDatabase _realtimeDb = FirebaseDatabase.instance;

  /// Register user and store data in Firestore
  Future<UserCredential> registerWithEmailAndPassword(
    User user,
    BuildContext context,
  ) async {
    try {
      // Firebase Auth registration
      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.pass,
          );

      // Extract UID
      String uid = userCredentials.user!.uid;
      
     
      // Convert user to Map and store in Firestore
      // Map<String, dynamic> userData = convertUserToMap(user);
      // await store.collection("users").doc(uid).set(userData);

      // ✅ Show success message
      showSnackBar(context, 'User Successfully Registered!', Colors.green);

      return userCredentials;
    } on FirebaseAuthException catch (e) {
      // ❌ Show error message
      showSnackBar(
        context,
        e.message ?? 'An error occurred during registration',
        Colors.red,
      );
      throw e;
    }
  }

  /// Convert User or Athlete to a Map for Firestore
  // Map<String, dynamic> convertUserToMap(User user) {

  //   Map<String, dynamic> data ={};
  //   if (user is Athlete) {
  //     Map<String, dynamic> athlete = {
  //       "name": user.name,
  //       "email": user.email,
  //       "role": user.role,
  //       "tel": user.tel,
  //       "province": user.province,
  //       "city": user.city,
  //       "date": user.date,
  //       "sport": user.sport,
  //       "experience": user.experience,
  //       "institute": user.institute,
  //       "gender": user.gender,
  //     };
  //     data =athlete;
  //   };

  //   if(user is Sponsor){
  //     Map<String, dynamic> sponsor ={
  //       "name": user.name,
  //       "email": user.email,
  //       "role": user.role,
  //       "tel": user.tel,
  //       "province": user.province,
  //       "city": user.city,
  //       "date": user.date,
  //       "company" :user.companyname,
  //       "sportIntrested" :user.intrestedSport,
  //       "orgSector" :user.orgSector

  //     };
  //     data = sponsor;
  //   }
    

  //   return data;
    

    
  // }
}































































































