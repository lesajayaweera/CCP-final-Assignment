import 'package:flutter/material.dart';

class RegistrationForm2 extends StatefulWidget {
  final String selectedRole;
  final String email;
  final int telno;
  final String password;

  const RegistrationForm2({super.key, required this.selectedRole, required this.email, required this.telno, required this.password});

  @override
  _RegistrationForm2State createState() => _RegistrationForm2State();
}

class _RegistrationForm2State extends State<RegistrationForm2> {

//  initialization the form keys and editing controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final  TextEditingController _nameController =TextEditingController();
  


  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}