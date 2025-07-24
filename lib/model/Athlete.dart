
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/model/auth.dart';
import 'package:flutter/material.dart';

class Athlete extends User {
  late String sport;
  late int experience;
  late String institute;
  late String gender;

  Athlete(
    String name,
    String email,
    String role,
    String pass,
    String tel,
    String city,
    String province,
    String date,
    this.sport,
    this.experience,
    this.institute,
    this.gender
  ) : super(name, email, role, pass, tel, city, province, date);

  @override
  void Register(BuildContext context) async {
  Firebase firebase = Firebase();

  try {
    await firebase.registerWithEmailAndPassword(this, context);
   
  } catch (e) {
    showSnackBar(context, 'Failed to Register from the Athlete class', Colors.red);
  }
}
  

  @override
  void Login(BuildContext context) async {
    
  }
}
