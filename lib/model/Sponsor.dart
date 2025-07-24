import 'package:flutter/material.dart';
import 'package:sport_ignite/model/User.dart';

class Sponsor extends User {
  late String companyname;
  late String intrestedSport;
  late String orgSector;

  Sponsor(
    String name,
    String email,
    String role,
    String pass,
    String tel,
    String city,
    String province,
    String date,
    this.companyname,
    this.intrestedSport,
    this.orgSector,
  ) : super(name, email, role, pass, tel, city, province, date);

  @override
  void Register(BuildContext context) {
    // TODO: implement Register
  }

  @override
  void Login(BuildContext context) {
    // TODO: implement Login
  }
}
