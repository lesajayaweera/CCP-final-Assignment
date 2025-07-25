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


//Reusable SnackBar method
  void showSnackBar(BuildContext context, String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
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
        content: Center(
          child: CircularProgressIndicator(),
        ),
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
