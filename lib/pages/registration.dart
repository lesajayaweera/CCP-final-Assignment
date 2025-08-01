import 'dart:io';

import 'package:sport_ignite/config/essentials.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_ignite/model/Athlete.dart';
import 'package:sport_ignite/model/Sponsor.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // for Athlete
  final TextEditingController _experienceController =
      TextEditingController(); // experience
  String? _selectedOrganization; // school or club
  String? _slectedGender; // gender
  String? _selectedSport; // selected sport

  // sponsor
  final TextEditingController _companyController =
      TextEditingController(); // company Name
  String? _selectedIntrested; // sport instrested
  String? _selectedSector; // organization level

  // common
  DateTime? selectedDate;
  String? _selectedRole; // role selected
  String? _selectedProvince; // province selected
  File? profileImage; // iser's profile picture
  final TextEditingController _nameController =
      TextEditingController(); // user name
  final TextEditingController dobController =
      TextEditingController(); // date of birth
  final TextEditingController cityController = TextEditingController(); // city
  final TextEditingController _emailController =
      TextEditingController(); // email
  final TextEditingController _passwordController =
      TextEditingController(); // password
  final TextEditingController _teleController =
      TextEditingController(); // telephone number

  bool _isPasswordVisible = false;
  int _currentStep = 0;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == 'Athlete') {
        //
        int experience = int.tryParse(_experienceController.text.trim()) ?? 0;
        if (_selectedSport == null ||
            _selectedOrganization == null ||
            _slectedGender == null) {
          showSnackBar(
            context,
            "Please select sport, organization, and gender",
            Colors.red,
          );
          return;
        }

        // Build Athlete object
        Athlete athlete = Athlete(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _selectedRole!,
          _passwordController.text,
          _teleController.text.trim(),
          cityController.text.trim(),
          _selectedProvince ?? '',
          dobController.text.trim(),
          _selectedSport!,
          experience,
          _selectedOrganization!,
          _slectedGender!,
          profileImage,
        );

        athlete.Register(context);
      }
      if (_selectedRole == 'Sponsor') {
        if (_selectedIntrested == null || _selectedSector == null) {
          showSnackBar(
            context,
            "Please select Sport you are Intrested and Your Organization details",
            Colors.red,
          );
          return;
        }

        Sponsor sponsor = Sponsor(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _selectedRole!,
          _passwordController.text,
          _teleController.text.trim(),
          cityController.text.trim(),
          _selectedProvince ?? '',
          dobController.text.trim(),
          _companyController.text.trim(),
          _selectedIntrested!,
          _selectedSector!,
          profileImage,
        );

        sponsor.Register(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Image.asset('asset/image/Logo.png', width: 100),
                    const SizedBox(height: 8),
                    Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                    ),
                    height(16),

                    // MULTI-STEP FORM
                    SizedBox(
                      height: 400,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [_buildStep1(), _buildStep2(), _buildStep3()],
                      ),
                    ),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: _previousPage,
                            child: const Text("Back"),
                          ),
                        ElevatedButton(
                          onPressed: _currentStep == 2
                              ? _submitForm
                              : _nextPage,
                          child: Text(_currentStep == 2 ? "Register" : "Next"),
                        ),
                      ],
                    ),

                    height(16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Step 1: Basic Information",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        height(16),
        TextFormField(
          controller: _emailController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            final emailValid = RegExp(
              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
            ).hasMatch(value);
            if (!emailValid) return 'Enter a valid email address';
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        height(16),
        TextFormField(
          controller: _teleController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your phone number';
            }
            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
              return 'Phone number must be 10 digits';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
        ),
        height(16),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
        height(16),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          decoration: const InputDecoration(
            labelText: "Select Role",
            border: OutlineInputBorder(),
          ),
          items: ['Sponsor', 'Athlete']
              .map((role) => DropdownMenuItem(value: role, child: Text(role)))
              .toList(),
          onChanged: (value) {
            setState(() => _selectedRole = value);
          },
          validator: (value) =>
              value == null ? 'Please select your role' : null,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 2: Tell us About Yourself',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          height(16),

          // Profile Image Picker
          Center(
            child: GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : null,
                child: profileImage == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
          ),
          height(16),

          // Name TextField
          TextFormField(
            controller: _nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your Name';
              }
              else if (value.length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_sharp),
              border: OutlineInputBorder(),
            ),
          ),
          height(16),

          // Province and City side-by-side
          DropdownButtonFormField<String>(
            value: _selectedProvince,
            decoration: const InputDecoration(
              labelText: "Province",
              border: OutlineInputBorder(),
            ),
            items: provinces
                .map(
                  (province) =>
                      DropdownMenuItem(value: province, child: Text(province)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => _selectedProvince = value);
            },
            validator: (value) =>
                value == null ? 'Please select your province' : null,
          ),
          const SizedBox(height: 5), // spacing between fields
          TextFormField(
            controller: cityController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your City';
              }
              else if (value.length < 2) {
                return 'City must be at least 2 characters';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'City',
              prefixIcon: Icon(Icons.location_city),
              border: OutlineInputBorder(),
            ),
          ),
          height(16),
          TextFormField(
            controller: dobController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your Date of Birth';
              }
              if (selectedDate != null) {
                final today = DateTime.now();
                if (selectedDate!.isAfter(today)) {
                  return 'Date of Birth cannot be in the future';
                }
              }
              if (selectedDate != null &&
                  selectedDate!.year < 1900) {
                return 'Date of Birth cannot be before 1900';
              }
              return null;
            },
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                  dobController.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                });
              }
            },
          ),
          height(16),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    if (_selectedRole == "Athlete") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Step 3: Athlete Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          height(16),
          DropdownButtonFormField<String>(
            value: _selectedSport,
            decoration: const InputDecoration(
              labelText: 'Sport',
              border: OutlineInputBorder(),
            ),
            items: sports.map((String sport) {
              return DropdownMenuItem<String>(value: sport, child: Text(sport));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSport = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a sport';
              }
              if (!sports.contains(value)) {
                return 'Invalid sport selected';
              }

              return null;
            },

          ),
          height(16),
          TextFormField(
            controller: _experienceController,
            decoration: const InputDecoration(
              labelText: 'Years of Experience',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your experience';
              }
              
              if (value.length < 2) {
                return 'Experience must be at least 2 digits';
              }
              final number = int.tryParse(value);
              if (number == null) {
                return 'Experience must be a number';
              }
              if (number < 0) {
                return 'Experience can’t be negative';
              }

              return null;
            },
          ),
          height(16),
          DropdownButtonFormField<String>(
            value: _selectedOrganization,
            decoration: const InputDecoration(
              labelText: "Select institution",
              border: OutlineInputBorder(),
            ),
            items: organizations
                .map((org) => DropdownMenuItem(value: org, child: Text(org)))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedOrganization = value);
            },
            validator: (value) => value == null
                ? 'Please select what you are currently playing to'
                : null,
          ),
          height(16),
          DropdownButtonFormField<String>(
            value: _slectedGender,
            decoration: const InputDecoration(
              labelText: "Select Gender",
              border: OutlineInputBorder(),
            ),
            items: gender
                .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => _slectedGender = value);
            },
            validator: (value) =>
                value == null ? 'Please select your Gender!' : null,
          ),
        ],
      );
    } else if (_selectedRole == "Sponsor") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Step 3: Sponsor Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          height(16),
          TextFormField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: 'Company Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter company name' : null,
          ),
          height(16),
          DropdownButtonFormField<String>(
            value: _selectedIntrested,
            decoration: const InputDecoration(
              labelText: 'Intrested in Sports',
              border: OutlineInputBorder(),
            ),
            items: sports.map((String sport) {
              return DropdownMenuItem<String>(value: sport, child: Text(sport));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedIntrested = newValue!;
              });
            },
            validator: (value) =>
                value == null || value.isEmpty ? 'Please select a sport' : null,
          ),
          height(16),

          DropdownButtonFormField<String>(
            value: _selectedSector,
            decoration: const InputDecoration(
              labelText: 'Organization Sector',
              border: OutlineInputBorder(),
            ),
            items: sector.map((String sport) {
              return DropdownMenuItem<String>(value: sport, child: Text(sport));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSector = newValue!;
              });
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Please select a Sector'
                : null,
          ),
        ],
      );
    } else {
      return const Center(child: Text("Please select a role"));
    }
  }
}

Widget height(double size) {
  return SizedBox(height: size);
}

Widget Width(double size) {
  return SizedBox(width: size);
}
