// import 'dart:io';

// import 'package:sport_ignite/config/essentials.dart';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sport_ignite/model/Athlete.dart';
// import 'package:sport_ignite/model/Sponsor.dart';

// // need to add the athletes 's full name
// class Registration extends StatefulWidget {
//   const Registration({super.key});

//   @override
//   State<Registration> createState() => _RegistrationState();
// }

// class _RegistrationState extends State<Registration> {
//   final PageController _pageController = PageController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   // for Athlete
//   final TextEditingController _experienceController =
//       TextEditingController(); // experience
//   String? _selectedOrganization; // school or club
//   String? _slectedGender; // gender
//   String? _selectedSport; // selected sport

//   // sponsor
//   final TextEditingController _companyController =
//       TextEditingController(); // company Name
//   String? _selectedIntrested; // sport instrested
//   String? _selectedSector; // organization level

//   // common
//   DateTime? selectedDate;
//   String? _selectedRole; // role selected
//   String? _selectedProvince; // province selected
//   File? profileImage; // iser's profile picture
//   final TextEditingController _nameController =
//       TextEditingController(); // user name
//   final TextEditingController dobController =
//       TextEditingController(); // date of birth
//   final TextEditingController cityController = TextEditingController(); // city
//   final TextEditingController _emailController =
//       TextEditingController(); // email
//   final TextEditingController _passwordController =
//       TextEditingController(); // password
//   final TextEditingController _teleController =
//       TextEditingController(); // telephone number

//   final TextEditingController _fullNameController =
//       TextEditingController(); // full name

//   bool _isPasswordVisible = false;
//   int _currentStep = 0;

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         profileImage = File(picked.path);
//       });
//     }
//   }

//   void _nextPage() {
//     if (_formKey.currentState!.validate()) {
//       if (_currentStep < 2) {
//         setState(() => _currentStep++);
//         _pageController.nextPage(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       }
//     }
//   }

//   void _previousPage() {
//     if (_currentStep > 0) {
//       setState(() => _currentStep--);
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedRole == 'Athlete') {
//         //
//         int experience = int.tryParse(_experienceController.text.trim()) ?? 0;
//         if (_selectedSport == null ||
//             _selectedOrganization == null ||
//             _slectedGender == null) {
//           showSnackBar(
//             context,
//             "Please select sport, organization, and gender",
//             Colors.red,
//           );
//           return;
//         }

//         // Build Athlete object
//         Athlete athlete = Athlete(
//           _nameController.text.trim(),
//           _emailController.text.trim(),
//           _selectedRole!,
//           _passwordController.text,
//           _teleController.text.trim(),
//           cityController.text.trim(),
//           _selectedProvince ?? '',
//           dobController.text.trim(),
//           _selectedSport!,
//           experience,
//           _selectedOrganization!,
//           _slectedGender!,
//           profileImage,
//           _fullNameController.text.trim(),
//         );

//         athlete.Register(context);
//       }
//       if (_selectedRole == 'Sponsor') {
//         if (_selectedIntrested == null || _selectedSector == null) {
//           showSnackBar(
//             context,
//             "Please select Sport you are Intrested and Your Organization details",
//             Colors.red,
//           );
//           return;
//         }

//         Sponsor sponsor = Sponsor(
//           _nameController.text.trim(),
//           _emailController.text.trim(),
//           _selectedRole!,
//           _passwordController.text,
//           _teleController.text.trim(),
//           cityController.text.trim(),
//           _selectedProvince ?? '',
//           dobController.text.trim(),
//           _companyController.text.trim(),
//           _selectedIntrested!,
//           _selectedSector!,
//           profileImage,
//         );

//         sponsor.Register(context);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Card(
//             elevation: 10,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             margin: const EdgeInsets.symmetric(horizontal: 24),
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset('asset/image/Logo.png', width: 100),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Sign Up",
//                       style: Theme.of(context).textTheme.headlineSmall
//                           ?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                     ),
//                     height(16),

//                     // MULTI-STEP FORM
//                     SizedBox(
//                       height: 400,
//                       child: PageView(
//                         controller: _pageController,
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: [_buildStep1(), _buildStep2(), _buildStep3()],
//                       ),
//                     ),

//                     // Navigation Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         if (_currentStep > 0)
//                           TextButton(
//                             onPressed: _previousPage,
//                             child: const Text("Back"),
//                           ),
//                         ElevatedButton(
//                           onPressed: _currentStep == 2
//                               ? _submitForm
//                               : _nextPage,
//                           child: Text(_currentStep == 2 ? "Register" : "Next"),
//                         ),
//                       ],
//                     ),

//                     height(16),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Already have an account?"),
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text("Login"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStep1() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Step 1: Basic Information",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         height(16),
//         TextFormField(
//           controller: _emailController,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Please enter your email';
//             }
//             final emailValid = RegExp(
//               r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
//             ).hasMatch(value);
//             if (!emailValid) return 'Enter a valid email address';
//             return null;
//           },
//           decoration: const InputDecoration(
//             labelText: 'Email',
//             prefixIcon: Icon(Icons.email_outlined),
//             border: OutlineInputBorder(),
//           ),
//         ),
//         height(16),
//         TextFormField(
//           controller: _teleController,
//           keyboardType: TextInputType.phone,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Please enter your phone number';
//             }
//             if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//               return 'Phone number must be 10 digits';
//             }
//             return null;
//           },
//           decoration: const InputDecoration(
//             labelText: 'Phone Number',
//             prefixIcon: Icon(Icons.phone),
//             border: OutlineInputBorder(),
//           ),
//         ),
//         height(16),
//         TextFormField(
//           controller: _passwordController,
//           obscureText: !_isPasswordVisible,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your password';
//             }
//             if (value.length < 6) {
//               return 'Password must be at least 6 characters';
//             }
//             return null;
//           },
//           decoration: InputDecoration(
//             labelText: 'Password',
//             prefixIcon: const Icon(Icons.lock_outline),
//             border: const OutlineInputBorder(),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isPasswordVisible = !_isPasswordVisible;
//                 });
//               },
//             ),
//           ),
//         ),
//         height(16),
//         DropdownButtonFormField<String>(
//           value: _selectedRole,
//           decoration: const InputDecoration(
//             labelText: "Select Role",
//             border: OutlineInputBorder(),
//           ),
//           items: ['Sponsor', 'Athlete']
//               .map((role) => DropdownMenuItem(value: role, child: Text(role)))
//               .toList(),
//           onChanged: (value) {
//             setState(() => _selectedRole = value);
//           },
//           validator: (value) =>
//               value == null ? 'Please select your role' : null,
//         ),
//       ],
//     );
//   }

//   Widget _buildStep2() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Step 2: Tell us About Yourself',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           height(16),

//           // Profile Image Picker
//           Center(
//             child: GestureDetector(
//               onTap: pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: profileImage != null
//                     ? FileImage(profileImage!)
//                     : null,
//                 child: profileImage == null
//                     ? const Icon(Icons.camera_alt, size: 40)
//                     : null,
//               ),
//             ),
//           ),
//           height(16),

//           // Name TextField
//           TextFormField(
//             controller: _nameController,
//             validator: (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Please enter your Name';
//               } else if (value.length < 3) {
//                 return 'Name must be at least 3 characters';
//               }
//               return null;
//             },
//             decoration: const InputDecoration(
//               labelText: 'Name',
//               prefixIcon: Icon(Icons.person_sharp),
//               border: OutlineInputBorder(),
//             ),
//           ),
//           height(16),

//           // Province and City side-by-side
//           DropdownButtonFormField<String>(
//             value: _selectedProvince,
//             decoration: const InputDecoration(
//               labelText: "Province",
//               border: OutlineInputBorder(),
//             ),
//             items: provinces
//                 .map(
//                   (province) =>
//                       DropdownMenuItem(value: province, child: Text(province)),
//                 )
//                 .toList(),
//             onChanged: (value) {
//               setState(() => _selectedProvince = value);
//             },
//             validator: (value) =>
//                 value == null ? 'Please select your province' : null,
//           ),
//           const SizedBox(height: 5), // spacing between fields
//           TextFormField(
//             controller: cityController,
//             validator: (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Please enter your City';
//               } else if (value.length < 2) {
//                 return 'City must be at least 2 characters';
//               }
//               return null;
//             },
//             decoration: const InputDecoration(
//               labelText: 'City',
//               prefixIcon: Icon(Icons.location_city),
//               border: OutlineInputBorder(),
//             ),
//           ),
//           height(16),
//           TextFormField(
//             controller: dobController,
//             readOnly: true,
//             decoration: const InputDecoration(
//               labelText: 'Date of Birth',
//               prefixIcon: Icon(Icons.calendar_today),
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select your Date of Birth';
//               }
//               if (selectedDate != null) {
//                 final today = DateTime.now();
//                 if (selectedDate!.isAfter(today)) {
//                   return 'Date of Birth cannot be in the future';
//                 }
//               }
//               if (selectedDate != null && selectedDate!.year < 1900) {
//                 return 'Date of Birth cannot be before 1900';
//               }
//               return null;
//             },
//             onTap: () async {
//               DateTime? pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime(2000),
//                 firstDate: DateTime(1900),
//                 lastDate: DateTime.now(),
//               );
//               if (pickedDate != null) {
//                 setState(() {
//                   selectedDate = pickedDate;
//                   dobController.text =
//                       "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//                 });
//               }
//             },
//           ),
//           height(16),
//         ],
//       ),
//     );
//   }

//   Widget _buildStep3() {
//     if (_selectedRole == "Athlete") {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Step 3: Athlete Details",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           height(16),
//           DropdownButtonFormField<String>(
//             value: _selectedSport,
//             decoration: const InputDecoration(
//               labelText: 'Sport',
//               border: OutlineInputBorder(),
//             ),
//             items: sports.map((String sport) {
//               return DropdownMenuItem<String>(value: sport, child: Text(sport));
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedSport = newValue!;
//               });
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select a sport';
//               }
//               if (!sports.contains(value)) {
//                 return 'Invalid sport selected';
//               }

//               return null;
//             },
//           ),
//           height(16),
//           TextFormField(
//             controller: _experienceController,
//             decoration: const InputDecoration(
//               labelText: 'Years of Experience',
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Enter your experience';
//               }

//               if (value.length < 2) {
//                 return 'Experience must be at least 2 digits';
//               }
//               final number = int.tryParse(value);
//               if (number == null) {
//                 return 'Experience must be a number';
//               }
//               if (number < 0) {
//                 return 'Experience can’t be negative';
//               }

//               return null;
//             },
//           ),

//           TextFormField(
//             controller: _fullNameController,
//             decoration: const InputDecoration(
//               labelText: 'Full Name',
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Enter your full name';
//               }

//               if (value.trim().length < 2) {
//                 return 'Full name must be at least 2 characters';
//               }

//               // Allow letters, spaces, periods, and ampersands
//               final nameRegExp = RegExp(r"^[a-zA-Z\s.&]+$");
//               if (!nameRegExp.hasMatch(value)) {
//                 return 'Full name can only contain letters, spaces, ".", and "&"';
//               }

//               return null;
//             },
//           ),

//           height(16),
//           DropdownButtonFormField<String>(
//             value: _selectedOrganization,
//             decoration: const InputDecoration(
//               labelText: "Select institution",
//               border: OutlineInputBorder(),
//             ),
//             items: organizations
//                 .map((org) => DropdownMenuItem(value: org, child: Text(org)))
//                 .toList(),
//             onChanged: (value) {
//               setState(() => _selectedOrganization = value);
//             },
//             validator: (value) => value == null
//                 ? 'Please select what you are currently playing to'
//                 : null,
//           ),
//           height(16),
//           DropdownButtonFormField<String>(
//             value: _slectedGender,
//             decoration: const InputDecoration(
//               labelText: "Select Gender",
//               border: OutlineInputBorder(),
//             ),
//             items: gender
//                 .map(
//                   (value) => DropdownMenuItem(value: value, child: Text(value)),
//                 )
//                 .toList(),
//             onChanged: (value) {
//               setState(() => _slectedGender = value);
//             },
//             validator: (value) =>
//                 value == null ? 'Please select your Gender!' : null,
//           ),
//         ],
//       );
//     } else if (_selectedRole == "Sponsor") {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Step 3: Sponsor Details",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           height(16),
//           TextFormField(
//             controller: _companyController,
//             decoration: const InputDecoration(
//               labelText: 'Company Name',
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) =>
//                 value == null || value.isEmpty ? 'Enter company name' : null,
//           ),
//           height(16),
//           DropdownButtonFormField<String>(
//             value: _selectedIntrested,
//             decoration: const InputDecoration(
//               labelText: 'Intrested in Sports',
//               border: OutlineInputBorder(),
//             ),
//             items: sports.map((String sport) {
//               return DropdownMenuItem<String>(value: sport, child: Text(sport));
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedIntrested = newValue!;
//               });
//             },
//             validator: (value) =>
//                 value == null || value.isEmpty ? 'Please select a sport' : null,
//           ),
//           height(16),

//           DropdownButtonFormField<String>(
//             value: _selectedSector,
//             decoration: const InputDecoration(
//               labelText: 'Organization Sector',
//               border: OutlineInputBorder(),
//             ),
//             items: sector.map((String sport) {
//               return DropdownMenuItem<String>(value: sport, child: Text(sport));
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedSector = newValue!;
//               });
//             },
//             validator: (value) => value == null || value.isEmpty
//                 ? 'Please select a Sector'
//                 : null,
//           ),
//         ],
//       );
//     } else {
//       return const Center(child: Text("Please select a role"));
//     }
//   }
// }

// Widget height(double size) {
//   return SizedBox(height: size);
// }

// Widget Width(double size) {
//   return SizedBox(width: size);
// }

import 'dart:io';

import 'package:sport_ignite/config/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_ignite/model/Athlete.dart';
import 'package:sport_ignite/model/Sponsor.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers and variables (keeping your existing ones)
  final TextEditingController _experienceController = TextEditingController();
  String? _selectedOrganization;
  String? _slectedGender;
  String? _selectedSport;

  final TextEditingController _companyController = TextEditingController();
  String? _selectedIntrested;
  String? _selectedSector;

  DateTime? selectedDate;
  String? _selectedRole;
  String? _selectedProvince;
  File? profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teleController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _progressController.dispose();
    // Dispose all controllers
    _experienceController.dispose();
    _companyController.dispose();
    _nameController.dispose();
    dobController.dispose();
    cityController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _teleController.dispose();
    _fullNameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    HapticFeedback.lightImpact();
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      if (_currentStep < 2) {
        setState(() => _currentStep++);
        _progressController.forward();
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  void _previousPage() {
    HapticFeedback.lightImpact();
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _progressController.reverse();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      HapticFeedback.mediumImpact();
      
      try {
        if (_selectedRole == 'Athlete') {
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
            _fullNameController.text.trim(),
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
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF8b5fbf),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header with progress
                  _buildHeader(),
                  
                  // Main content
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          children: [
                            // Progress indicator
                            _buildProgressIndicator(),
                            
                            // Form content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Form(
                                  key: _formKey,
                                  child: PageView(
                                    controller: _pageController,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      _buildStep1(),
                                      _buildStep2(),
                                      _buildStep3()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            // Navigation buttons
                            _buildNavigationButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset('asset/image/Logo.png', width: 40),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Create Account",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Join the sports community today!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              bool isActive = index <= _currentStep;
              bool isCompleted = index < _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: isActive
                              ? const LinearGradient(
                                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                )
                              : null,
                          color: isActive ? null : Colors.grey.shade200,
                        ),
                      ),
                    ),
                    if (index < 2) const SizedBox(width: 8),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel("Basic Info", 0),
              _buildStepLabel("Personal", 1),
              _buildStepLabel("Details", 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepLabel(String label, int step) {
    bool isActive = step <= _currentStep;
    return Text(
      label,
      style: TextStyle(
        color: isActive ? const Color(0xFF667eea) : Colors.grey.shade500,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        fontSize: 14,
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(right: 12),
                child: OutlinedButton.icon(
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : (_currentStep == 2 ? _submitForm : _nextPage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentStep == 2 ? "Create Account" : "Continue",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (_currentStep < 2) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedField({required Widget child, int delay = 0}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + delay * 50),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedField(
            child: const Text(
              "Let's get started",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAnimatedField(
            delay: 1,
            child: Text(
              "Enter your basic information",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _buildAnimatedField(
            delay: 2,
            child: _buildModernTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'example@email.com',
              icon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final emailValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value);
                if (!emailValid) return 'Enter a valid email address';
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 3,
            child: _buildModernTextField(
              controller: _teleController,
              label: 'Phone Number',
              hint: '0771234567',
              icon: Icons.phone_outlined,
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
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 4,
            child: _buildModernTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Create a secure password',
              icon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 5,
            child: _buildModernDropdown(
              value: _selectedRole,
              label: 'I am a',
              items: ['Sponsor', 'Athlete'],
              onChanged: (value) {
                setState(() => _selectedRole = value);
              },
              validator: (value) => value == null ? 'Please select your role' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedField(
            child: const Text(
              "Personal Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAnimatedField(
            delay: 1,
            child: Text(
              "Tell us more about yourself",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Profile Image Picker
          _buildAnimatedField(
            delay: 2,
            child: Center(
              child: GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: profileImage == null
                        ? const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667eea).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: profileImage != null
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(profileImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAnimatedField(
            delay: 3,
            child: Center(
              child: Text(
                "Tap to select profile photo",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _buildAnimatedField(
            delay: 4,
            child: _buildModernTextField(
              controller: _nameController,
              label: 'Display Name',
              hint: 'How should we call you?',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                } else if (value.length < 3) {
                  return 'Name must be at least 3 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 5,
            child: _buildModernDropdown(
              value: _selectedProvince,
              label: 'Province',
              items: provinces,
              onChanged: (value) {
                setState(() => _selectedProvince = value);
              },
              validator: (value) => value == null ? 'Please select your province' : null,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 6,
            child: _buildModernTextField(
              controller: cityController,
              label: 'City',
              hint: 'Which city do you live in?',
              icon: Icons.location_city_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your city';
                } else if (value.length < 2) {
                  return 'City must be at least 2 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 7,
            child: _buildModernTextField(
              controller: dobController,
              label: 'Date of Birth',
              hint: 'Select your birth date',
              icon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: () async {
                HapticFeedback.lightImpact();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF667eea),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    dobController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your date of birth';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    if (_selectedRole == "Athlete") {
      return _buildAthleteForm();
    } else if (_selectedRole == "Sponsor") {
      return _buildSponsorForm();
    } else {
      return const Center(
        child: Text(
          "Please select a role in the previous step",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildAthleteForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedField(
            child: const Text(
              "Athlete Profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAnimatedField(
            delay: 1,
            child: Text(
              "Complete your sporting profile",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _buildAnimatedField(
            delay: 2,
            child: _buildModernTextField(
              controller: _fullNameController,
              label: 'Full Legal Name',
              hint: 'Your complete name',
              icon: Icons.badge_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your full name';
                }
                if (value.trim().length < 2) {
                  return 'Full name must be at least 2 characters';
                }
                final nameRegExp = RegExp(r"^[a-zA-Z\s.&]+$");
                if (!nameRegExp.hasMatch(value)) {
                  return 'Full name can only contain letters, spaces, ".", and "&"';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 3,
            child: _buildModernDropdown(
              value: _selectedSport,
              label: 'Primary Sport',
              items: sports,
              onChanged: (value) {
                setState(() => _selectedSport = value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a sport';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 4,
            child: _buildModernTextField(
              controller: _experienceController,
              label: 'Years of Experience',
              hint: 'How long have you been playing?',
              icon: Icons.timeline_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your experience';
                }
                final number = int.tryParse(value);
                if (number == null) {
                  return 'Experience must be a number';
                }
                if (number < 0) {
                  return 'Experience cannot be negative';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 5,
            child: _buildModernDropdown(
              value: _selectedOrganization,
              label: 'Current Institution',
              items: organizations,
              onChanged: (value) {
                setState(() => _selectedOrganization = value);
              },
              validator: (value) => value == null ? 'Please select your institution' : null,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 6,
            child: _buildModernDropdown(
              value: _slectedGender,
              label: 'Gender',
              items: gender,
              onChanged: (value) {
                setState(() => _slectedGender = value);
              },
              validator: (value) => value == null ? 'Please select your gender' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedField(
            child: const Text(
              "Sponsor Profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAnimatedField(
            delay: 1,
            child: Text(
              "Set up your sponsorship profile",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _buildAnimatedField(
            delay: 2,
            child: _buildModernTextField(
              controller: _companyController,
              label: 'Company Name',
              hint: 'Your organization name',
              icon: Icons.business_outlined,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter company name' : null,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 3,
            child: _buildModernDropdown(
              value: _selectedIntrested,
              label: 'Sport Interest',
              items: sports,
              onChanged: (value) {
                setState(() => _selectedIntrested = value);
              },
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please select a sport' : null,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildAnimatedField(
            delay: 4,
            child: _buildModernDropdown(
              value: _selectedSector,
              label: 'Organization Sector',
              items: sector,
              onChanged: (value) {
                setState(() => _selectedSector = value);
              },
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a sector'
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(color: Colors.grey[500]),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildModernDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        dropdownColor: Colors.white,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
        icon: const SizedBox.shrink(), // Hide default dropdown icon
      ),
    );
  }
}

Widget height(double size) {
  return SizedBox(height: size);
}

Widget Width(double size) {
  return SizedBox(width: size);
}