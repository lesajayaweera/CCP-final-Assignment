// ignore_for_file: unused_local_variable

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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers
  final TextEditingController _experienceController = TextEditingController();
  String? _selectedOrganization;
  String? _selectedGender;
  String? _selectedSport;
  String? _selectedPosition;

  final TextEditingController _companyController = TextEditingController();
  String? _selectedInterested;
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

  // Focus nodes for better keyboard handling
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _companyFocus = FocusNode();
  final FocusNode _experienceFocus = FocusNode();

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

    // Setup keyboard listeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupKeyboardListener();
    });
  }

  void _setupKeyboardListener() {
    // Listen for focus changes to dismiss keyboard when navigating between pages
    [_emailFocus, _phoneFocus, _passwordFocus, _nameFocus, _cityFocus, 
     _fullNameFocus, _companyFocus, _experienceFocus].forEach((focus) {
      focus.addListener(() {
        if (!focus.hasFocus) {
          // Small delay to ensure smooth transitions
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              FocusScope.of(context).unfocus();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    
    // Dispose focus nodes
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();
    _cityFocus.dispose();
    _fullNameFocus.dispose();
    _companyFocus.dispose();
    _experienceFocus.dispose();
    
    // Dispose controllers
    _experienceController.dispose();
    _companyController.dispose();
    _nameController.dispose();
    dobController.dispose();
    cityController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _teleController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  List<String> _getCricketPositions() {
    return cricketPositions;
  }

  List<String> _getFootballPositions() {
    return footballPositions;
  }

  List<String> _getBasketballPositions() {
    return basketballPositions;
  }

  List<String> _getPositionsForSport(String sport) {
    switch (sport) {
      case 'Cricket':
        return _getCricketPositions();
      case 'Football':
        return _getFootballPositions();
      case 'Basketball':
        return _getBasketballPositions();
      default:
        return [];
    }
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
    // Dismiss keyboard before navigation
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      if (_currentStep < 2) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  void _previousPage() {
    // Dismiss keyboard before navigation
    FocusScope.of(context).unfocus();
    
    HapticFeedback.lightImpact();
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _submitForm() async {
    // Dismiss keyboard first
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      HapticFeedback.mediumImpact();
      
      try {
        if (_selectedRole == 'Athlete') {
          int experience = int.tryParse(_experienceController.text.trim()) ?? 0;
          if (_selectedSport == null ||
              _selectedOrganization == null ||
              _selectedGender == null) {
            showSnackBar(
              context,
              "Please select sport, organization, and gender",
              Colors.red,
            );
            return;
          }

          // Check if sport is selected and position is required but not selected
          if ((_selectedSport == 'Cricket' || _selectedSport == 'Football' || _selectedSport == 'Basketball') 
              && _selectedPosition == null) {
            showSnackBar(
              context,
              "Please select your position for $_selectedSport",
              Colors.red,
            );
            return;
          }

          Athlete athlete = Athlete(
            _nameController.text.trim(),      // name
            _emailController.text.trim(),     // email
            _selectedRole!,                   // role
            _passwordController.text,         // pass
            _teleController.text.trim(),      // tel
            cityController.text.trim(),       // city
            _selectedProvince ?? '',          // province
            dobController.text.trim(),        // date
            _selectedSport!,                  // sport
            experience,                       // experience
            _selectedOrganization!,           // institute
            _selectedGender!,                 // gender
            profileImage,                     // profile
            _fullNameController.text.trim(),  // fullName
            _selectedPosition ?? '',          // positions
          );

          athlete.Register(context);
        } else if (_selectedRole == 'Sponsor') {
          if (_selectedInterested == null || _selectedSector == null) {
            showSnackBar(
              context,
              "Please select Sport you are interested and Your Organization details",
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
            _selectedInterested!,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          // Progress indicator
                          _buildProgressIndicator(),
                          
                          // Form content
                          Expanded(
                            child: Form(
                              key: _formKey,
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
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
      ),
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
          const SizedBox(height: 16),
          const Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Join the sports community today!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              bool isActive = index <= _currentStep;
              
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel("Account", 0),
              _buildStepLabel("Personal", 1),
              _buildStepLabel("Profile", 2),
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
        fontSize: 13,
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: Container(
                height: 48,
                margin: const EdgeInsets.only(right: 12),
                child: OutlinedButton.icon(
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back, size: 18),
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
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          if (_currentStep < 2) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
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

  Widget _buildStep1() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Information",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Enter your basic account details",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          _buildTextField(
            controller: _emailController,
            focusNode: _emailFocus,
            nextFocus: _phoneFocus,
            label: 'Email Address',
            hint: 'example@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              final emailValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value);
              if (!emailValid) return 'Enter a valid email address';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _teleController,
            focusNode: _phoneFocus,
            nextFocus: _passwordFocus,
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
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _passwordController,
            focusNode: _passwordFocus,
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
          const SizedBox(height: 16),
          
          _buildDropdown(
            value: _selectedRole,
            label: 'I am a',
            items: const ['Sponsor', 'Athlete'],
            onChanged: (value) => setState(() => _selectedRole = value),
            validator: (value) => value == null ? 'Please select your role' : null,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personal Details",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Tell us more about yourself",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Profile Image Picker
          Center(
            child: GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 90,
                height: 90,
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
                      blurRadius: 12,
                      offset: const Offset(0, 4),
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
                        size: 28,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              "Tap to select profile photo",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          _buildTextField(
            controller: _nameController,
            focusNode: _nameFocus,
            nextFocus: _cityFocus,
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
          const SizedBox(height: 16),
          
          _buildDropdown(
            value: _selectedProvince,
            label: 'Province',
            items: provinces,
            onChanged: (value) => setState(() => _selectedProvince = value),
            validator: (value) => value == null ? 'Please select your province' : null,
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: cityController,
            focusNode: _cityFocus,
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
          const SizedBox(height: 16),
          
          _buildTextField(
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
          const SizedBox(height: 24),
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
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text(
            "Please select a role in step 1",
            style: TextStyle(
              fontSize: 16, 
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Widget _buildAthleteForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Athlete Profile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Complete your sporting profile",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          _buildTextField(
            controller: _fullNameController,
            focusNode: _fullNameFocus,
            nextFocus: _experienceFocus,
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
          const SizedBox(height: 16),
          
          _buildDropdown(
            value: _selectedSport,
            label: 'Primary Sport',
            items: sports,
            onChanged: (value) {
              setState(() {
                _selectedSport = value;
                // Reset position when sport changes
                if (value != 'Cricket' && value != 'Football' && value != 'Basketball') {
                  _selectedPosition = null;
                }
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a sport';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Show position dropdown for sports that have positions
          if (_selectedSport == 'Cricket' || _selectedSport == 'Football' || _selectedSport == 'Basketball') ...[
            _buildDropdown(
              value: _selectedPosition,
              label: '${_selectedSport} Position',
              items: _getPositionsForSport(_selectedSport!),
              onChanged: (value) => setState(() => _selectedPosition = value),
              validator: (value) {
                if ((_selectedSport == 'Cricket' || _selectedSport == 'Football' || _selectedSport == 'Basketball') 
                    && (value == null || value.isEmpty)) {
                  return 'Please select your position for $_selectedSport';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          
          _buildTextField(
            controller: _experienceController,
            focusNode: _experienceFocus,
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
          const SizedBox(height: 16),
          
          _buildDropdown(
            value: _selectedOrganization,
            label: 'Current Institution',
            items: organizations,
            onChanged: (value) => setState(() => _selectedOrganization = value),
            validator: (value) => value == null ? 'Please select your institution' : null,
          ),
          const SizedBox(height: 16),
          
          _buildDropdown(
            value: _selectedGender,
            label: 'Gender',
            items: gender,
            onChanged: (value) => setState(() => _selectedGender = value),
            validator: (value) => value == null ? 'Please select your gender' : null,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSponsorForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sponsor Profile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Set up your sponsorship profile",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          _buildTextField(
            controller: _companyController,
            focusNode: _companyFocus,
            label: 'Company Name',
            hint: 'Your organization name',
            icon: Icons.business_outlined,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter company name' : null,
          ),
          const SizedBox(height: 16),
          
          _buildDropdown(
            value: _selectedInterested,
            label: 'Sport Interest',
            items: sports,
            onChanged: (value) => setState(() => _selectedInterested = value),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please select a sport' : null,
          ),
          const SizedBox(height: 16),
          
          _buildDropdown(
            value: _selectedSector,
            label: 'Organization Sector',
            items: sector,
            onChanged: (value) => setState(() => _selectedSector = value),
            validator: (value) => value == null || value.isEmpty
                ? 'Please select a sector'
                : null,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    FocusNode? nextFocus,
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword && !_isPasswordVisible,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                    size: 20,
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
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
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

  Widget height(double size) {
    return SizedBox(height: size);
  }

  Widget Width(double size) {
    return SizedBox(width: size);
  }
}