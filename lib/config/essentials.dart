import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
final List<String> sports = [
  'Football',
  'Cricket',
  'Basketball',
  'Tennis',
  'Athletics',
];

final List<String> provinces = [
  'Central Province',
  'Eastern Province',
  'Northern Province',
  'Southern Province',
  'Western Province',
  'North Western Province',
  'North Central Province',
  'Uva Province',
  'Sabaragamuwa Province',
];


final List<String> organizations =[
  'School',
  'Club'
];

final List<String> gender =[
  'Male',
  'Female'
];

final List<String> sector =[
  'Private',
  'Government'
];


/// 🔁 Reusable SnackBar method
  void showSnackBar(BuildContext context, String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
      ),
    );
  }


void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return const AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}
