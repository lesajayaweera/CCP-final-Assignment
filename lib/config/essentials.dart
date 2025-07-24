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


// convert the image into base 64
Future<String> convertImageToBase64(File imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64String = base64Encode(imageBytes);
  return base64String;
}
