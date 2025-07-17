// pages/player_registration_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PlayerRegistrationPage extends StatefulWidget {
  @override
  _PlayerRegistrationPageState createState() => _PlayerRegistrationPageState();
}

class _PlayerRegistrationPageState extends State<PlayerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Text field controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController guardianNameController = TextEditingController();
  TextEditingController guardianPhoneController = TextEditingController();

  String selectedSport = "Football";
  File? profileImage;

  // Picks profile image from gallery
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  // Automatically update institution based on age
  void updateInstitution(String ageStr) {
    int? age = int.tryParse(ageStr);
    if (age == null) return;

    if (age <= 18) {
      institutionController.text = "School";
    } else {
      institutionController.text = "University / Club";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Picker
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : null,
                  child: profileImage == null
                      ? Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              SizedBox(height: 20),

              // Name
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your name";
                  return null;
                },
              ),

              // Full Name
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your Full name";
                  return null;
                },
              ),

              // Age
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Age"),
                onChanged: updateInstitution,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your age";
                  return null;
                },
              ),

              // Institution (auto-filled)
              TextFormField(
                controller: institutionController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Institution"),
              ),

              // Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your email";
                  return null;
                }, 
              ),

              // Contact Number
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Contact Number"),
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your contact number";
                  if (value.length != 10) return "Must be 10 digits.";
                  return null;
                },
              ),

              // Sport Dropdown
              DropdownButtonFormField<String>(
                value: selectedSport,
                decoration: InputDecoration(labelText: "Sport"),
                items: ["Football", "Athletics", "Aquatics"]
                    .map(
                      (sport) =>
                          DropdownMenuItem(child: Text(sport), value: sport),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSport = value!;
                  });
                },
              ),

              // Guardian Name
              TextFormField(
                controller: guardianNameController,
                decoration: InputDecoration(labelText: "Guardian Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your guardian name";
                  return null;
                },
              ),

              // Guardian Contact Number
              TextFormField(
                controller: guardianPhoneController,
                decoration: InputDecoration(labelText: "Guardian Contact"),
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter guardian contact number";
                  if (value.length != 10) return "Must be 10 digits.";
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // For now, just show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registration successful!")),
                    );
                  }
                },
                child: Text("Register"),
              ),
            ],
          ),
        ),
      );
  }
}


//Permission
//<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>