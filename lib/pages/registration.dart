// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import 'package:sport_ignite/pages/Login.dart';




// class Registration extends StatefulWidget {
//   const Registration({super.key});

//   @override
//   State<Registration> createState() => _RegistrationState();
// }

// class _RegistrationState extends State<Registration> {
//   bool _isPasswordVisible = false;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _teleController = TextEditingController();

//   String? _selectedRole;  // Holds Sponsor or Athlete

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Card(
//             elevation: 10,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             margin: const EdgeInsets.symmetric(horizontal: 24),
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.sports, size: 48, color: Colors.blue),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Sign Up",
//                       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       "Register to ignite your sporting journey!",
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             color: Colors.grey[700],
//                           ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 24),

//                     // Email Field
//                     TextFormField(
//                       controller: _emailController,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         final emailValid = RegExp(
//                           r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
//                         ).hasMatch(value);
//                         if (!emailValid) return 'Enter a valid email address';
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'Email',
//                         hintText: 'example@email.com',
//                         prefixIcon: Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Phone Number Field
//                     TextFormField(
//                       controller: _teleController,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter your phone number';
//                         }
//                         if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                           return 'Phone number must be 10 digits';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.phone,
//                       decoration: const InputDecoration(
//                         labelText: 'Phone Number',
//                         hintText: '07 XXX XXX XX',
//                         prefixIcon: Icon(Icons.phone),
//                         border: OutlineInputBorder(),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Role Dropdown: Sponsor or Athlete
                    

//                     // Password Field
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: !_isPasswordVisible,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         if (value.length < 6) {
//                           return 'Password must be at least 6 characters';
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         hintText: 'Enter your password',
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         border: const OutlineInputBorder(),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 24),
//                     DropdownButtonFormField<String>(
//                       value: _selectedRole,
//                       decoration: const InputDecoration(
//                         labelText: "Select Role",
//                         border: OutlineInputBorder(),
//                       ),
//                       items: ['Sponsor', 'Athlete']
//                           .map(
//                             (role) => DropdownMenuItem(
//                               value: role,
//                               child: Text(role),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedRole = value;
//                         });
//                       },
//                       validator: (value) =>
//                           value == null ? 'Please select your role' : null,
//                     ),
//                     const SizedBox(height: 16),


//                     // Register Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         onPressed: () {
//                           if (_formKey.currentState?.validate() ?? false) {
//                             // TODO: Add registration logic here
//                           }
//                         },
//                         child: Text(
                          
//                           "${_selectedRole != null ? _selectedRole:""} Register",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Login Redirect
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Have an account?"),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text("Login"),
//                         )
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
// }


import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  int _currentStep = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teleController = TextEditingController();

  final TextEditingController _sportController = TextEditingController(); // For Athlete
  final TextEditingController _experienceController = TextEditingController(); // For Athlete
  final TextEditingController _companyController = TextEditingController(); // For Sponsor
  final TextEditingController _interestAreaController = TextEditingController(); // For Sponsor


  final TextEditingController _genderController  = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController =TextEditingController();
  final TextEditingController _instituteCOntroller =TextEditingController();
  

  String? _selectedRole;

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save registration data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration submitted!")),
      );
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sports, size: 48, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // MULTI-STEP FORM
                    SizedBox(
                      height: 400,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildStep1(),
                          _buildStep2(),
                          _buildStep3(),
                        ],
                      ),
                    ),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          TextButton(
                              onPressed: _previousPage, child: const Text("Back")),
                        ElevatedButton(
                          onPressed: _currentStep == 2 ? _submitForm : _nextPage,
                          child: Text(_currentStep == 2 ? "Register" : "Next"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Login"),
                        )
                      ],
                    )
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
        const Text("Step 1: Basic Information",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            final emailValid =
                RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value);
            if (!emailValid) return 'Enter a valid email address';
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
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
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Step 2: Choose Role",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          decoration: const InputDecoration(
            labelText: "Select Role",
            border: OutlineInputBorder(),
          ),
          items: ['Sponsor', 'Athlete']
              .map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  ))
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

  Widget _buildStep3() {
    if (_selectedRole == "Athlete") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 3: Athlete Details",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _sportController,
            decoration: const InputDecoration(
              labelText: 'Sport',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter your sport' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _experienceController,
            decoration: const InputDecoration(
              labelText: 'Years of Experience',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter experience' : null,
          ),
        ],
      );
    } else if (_selectedRole == "Sponsor") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 3: Sponsor Details",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: 'Company Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter company name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _interestAreaController,
            decoration: const InputDecoration(
              labelText: 'Interest Area',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter interest area' : null,
          ),
        ],
      );
    } else {
      return const Center(child: Text("Please select a role"));
    }
  }
}

