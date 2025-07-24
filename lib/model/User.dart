import 'package:flutter/material.dart';
abstract class User {
  late String name;
  late String email;
  late String pass;
  late String tel;
  late String role;
  late String province;
  late String city;
  late String date;

  User(
    this.name,
    this.email,
    this.role,
    this.pass,
    this.tel,
    this.city,
    this.province,
    this.date,
  );

  void Register(BuildContext context);

  void Login(BuildContext context);
}
