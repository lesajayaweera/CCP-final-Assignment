import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

final List<String> organizations = ['School', 'Club'];

final List<String> gender = ['Male', 'Female'];

final List<String> sector = ['Private', 'Government'];

final List<String> cricketPositions = [
  'Batsman',
  'Bowler',
  'All-rounder',
  'Wicket-keeper',
  'Captain',
  'Opening Batsman',
  'Middle Order Batsman',
  'Fast Bowler',
  'Spin Bowler',
  'Wicket-keeper Batsman',
];

final List<String> footballPositions = [
  
  'Goalkeeper',
  'Right Back',
  'Left Back',
  'Center Back',
  'Sweeper',
  'Defensive Midfielder',
  'Central Midfielder',
  'Attacking Midfielder',
  'Right Midfielder',
  'Left Midfielder',
  'Right Winger',
  'Left Winger',
  'Striker',
  'Center Forward',
  'False 9',
];

final List<String> basketballPositions = [
  'Point Guard',
  'Shooting Guard',
  'Small Forward',
  'Power Forward',
  'Center',
  'Combo Guard',
  'Forward',
  'Sixth Man',
];

//Reusable SnackBar method
void showSnackBar(BuildContext context, String message, Color bgColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.visibility_off, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(message),
        ],
      ),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

//  Loading indicator
void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return const AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(child: CircularProgressIndicator()),
      );
    },
  );
}

//  to save the uid to the local storage
Future<void> saveUserUidLocally(String uid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
}

// Get the uid
Future<String?> getUserUidFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}

// removing the uid
Future<void> removeUserUid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('uid');
}

// method to pick image
Future<Uint8List?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  }
  return null;
}

// calculate the age
int calculateAge(DateTime birthDate) {
  final today = DateTime.now();
  int age = today.year - birthDate.year;

  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  return age;
}
