import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_ignite/config/essentials.dart';

class EditProfilePage extends StatefulWidget {
  final String uid;
  final String role; // 'Athlete' or 'Sponsor'

  const EditProfilePage({
    Key? key,
    required this.uid,
    required this.role,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _editedData;
  File? _profileImage;
  File? _backgroundImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isDataLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _fullNameController;
  late TextEditingController _companyController;
  late TextEditingController _emailController;
  late TextEditingController _telController;
  late TextEditingController _cityController;
  late TextEditingController _positionsController;
  late TextEditingController _experienceController;
  late TextEditingController _dateController;

  final List<String> _provinces = provinces;
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _institutes = organizations;
  final List<String> _orgStructures = sector;
  final List<String> _popularSports = sports;

  @override
  void initState() {
    super.initState();
    _editedData = {};
    _initializeControllers();
    _loadUserData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isDataLoading = true;
      });

      final userData = await getUserDetailsByUid(context, widget.uid);
      
      if (userData != null) {
        setState(() {
          _editedData = userData;
          _initializeControllers();
        });
        _animationController.forward();
      }
    } catch (e) {
      _showSnackBar('Error loading user data: $e', isError: true);
    } finally {
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: _editedData['name'] ?? '');
    _fullNameController = TextEditingController(text: _editedData['fullName'] ?? '');
    _companyController = TextEditingController(text: _editedData['company'] ?? '');
    _emailController = TextEditingController(text: _editedData['email'] ?? '');
    _telController = TextEditingController(text: _editedData['tel'] ?? '');
    _cityController = TextEditingController(text: _editedData['city'] ?? '');
    _positionsController = TextEditingController(text: _editedData['positions'] ?? '');
    _experienceController = TextEditingController(text: _editedData['experience']?.toString() ?? '');
    _dateController = TextEditingController(
      text: _editedData['date'] != null 
          ? DateTime.parse(_editedData['date']).toString().split(' ')[0]
          : '',
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _fullNameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _telController.dispose();
    _cityController.dispose();
    _positionsController.dispose();
    _experienceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(0xFF38A169),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  Future<void> _pickImage(String type) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          if (type == 'profile') {
            _profileImage = File(image.path);
          } else {
            _backgroundImage = File(image.path);
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', isError: true);
    }
  }

  Future<String?> _uploadImage(File image, String path) async {
    try {
      final Reference storageReference = FirebaseStorage.instance.ref().child(path);
      final UploadTask uploadTask = storageReference.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _updateData() {
    _editedData['name'] = _nameController.text;
    
    if (widget.role == 'Athlete') {
      _editedData['fullName'] = _fullNameController.text;
      _editedData['positions'] = _positionsController.text;
      _editedData['experience'] = int.tryParse(_experienceController.text) ?? 0;
    } else {
      _editedData['company'] = _companyController.text;
    }
    
    _editedData['tel'] = _telController.text;
    _editedData['city'] = _cityController.text;
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      _updateData();

      try {
        if (_profileImage != null) {
          final String? profileUrl = await _uploadImage(
            _profileImage!,
            'profile_images/${widget.uid}.jpg'
          );
          if (profileUrl != null) {
            _editedData['profile'] = profileUrl;
          }
        }

        if (_backgroundImage != null) {
          final String? backgroundUrl = await _uploadImage(
            _backgroundImage!,
            'background_images/${widget.uid}.jpg'
          );
          if (backgroundUrl != null) {
            _editedData['background'] = backgroundUrl;
          }
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
              'name': _editedData['name'],
              'email': _editedData['email'],
            });

        final collectionName = widget.role == 'Athlete' ? 'Athlete' : 'sponsor';
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(widget.uid)
            .update(_editedData);

        setState(() {
          _isLoading = false;
        });

        _showSnackBar('Profile updated successfully!');
        Navigator.of(context).pop(_editedData);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Error saving profile: $e', isError: true);
      }
    }
  }

  static Future<Map<String, dynamic>?> getUserDetailsByUid(
    BuildContext context,
    String uid,
  ) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found in users collection'), backgroundColor: Colors.red),
        );
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final role = userData['role']?.toString().toLowerCase();

      if (role == null || (role != 'athlete' && role != 'sponsor')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid or missing role for user'), backgroundColor: Colors.red),
        );
        return null;
      }

      String collectionName = role == 'athlete' ? 'Athlete' : 'sponsor';

      DocumentSnapshot roleDoc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(uid)
          .get();

      if (roleDoc.exists) {
        final roleData = roleDoc.data() as Map<String, dynamic>;

        return {
          'uid': uid,
          ...userData,
          ...roleData,
        };
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$role details not found'), backgroundColor: Colors.red),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e'), backgroundColor: Colors.red),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: _isDataLoading
          ? _buildLoadingScreen()
          : Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildModernAppBar(isDark),
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildProfileCard(isDark),
                                const SizedBox(height: 20),
                                _buildEditForm(isDark),
                                const SizedBox(height: 100), // Space for floating button
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLoading) _buildLoadingOverlay(),
                _buildFloatingActionButtons(isDark),
              ],
            ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667EEA),
            const Color(0xFF764BA2),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading your profile...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Saving changes...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 220,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF667EEA),
                const Color(0xFF764BA2),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: _backgroundImage != null
                    ? Image.file(_backgroundImage!, fit: BoxFit.cover)
                    : _editedData['background'] != null && _editedData['background'].isNotEmpty
                        ? Image.network(_editedData['background'], fit: BoxFit.cover)
                        : Container(),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: _buildIconButton(
                  Icons.camera_alt_outlined,
                  () => _pickImage('background'),
                  'Change Background',
                ),
              ),
            ],
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: _buildIconButton(
          Icons.arrow_back_ios,
          () => Navigator.of(context).pop(),
          'Go Back',
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed, String tooltip) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        tooltip: tooltip,
        splashRadius: 20,
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Container(
      transform: Matrix4.translationValues(0, -60, 0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : _editedData['profile'] != null && _editedData['profile'].isNotEmpty
                                ? NetworkImage(_editedData['profile']) as ImageProvider
                                : null,
                        child: _profileImage == null && (_editedData['profile'] == null || _editedData['profile'].isEmpty)
                            ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667EEA).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => _pickImage('profile'),
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.role == 'Athlete'
                      ? _editedData['fullName'] ?? _editedData['name'] ?? ''
                      : _editedData['name'] ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A202C),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF667EEA).withOpacity(0.1),
                        const Color(0xFF764BA2).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.role == 'Athlete'
                        ? '${_editedData['sport']} ${_editedData['role']}'
                        : '${_editedData['company']} • ${_editedData['role']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF667EEA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_editedData['city']}, ${_editedData['province']}',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm(bool isDark) {
    return Container(
      transform: Matrix4.translationValues(0, -40, 0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  'Edit ${widget.role == 'Athlete' ? 'Athlete' : 'Sponsor'} Profile',
                  widget.role == 'Athlete' ? Icons.sports : Icons.business_rounded,
                  isDark,
                ),
                const SizedBox(height: 32),
                
                _buildSectionHeader('Basic Information', Icons.person_outline_rounded, isDark),
                const SizedBox(height: 20),
                
                _buildModernTextField(
                  controller: _nameController,
                  label: widget.role == 'Athlete' ? 'Display Name' : 'Name',
                  icon: Icons.badge_outlined,
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                
                if (widget.role == 'Athlete') ...[
                  const SizedBox(height: 20),
                  _buildModernTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    icon: Icons.person_rounded,
                    isDark: isDark,
                  ),
                ],
                
                if (widget.role == 'Sponsor') ...[
                  const SizedBox(height: 20),
                  _buildModernTextField(
                    controller: _companyController,
                    label: 'Company Name',
                    icon: Icons.business_rounded,
                    hintText: 'Enter your company or organization name',
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Company name is required';
                      }
                      return null;
                    },
                  ),
                ],
                
                const SizedBox(height: 20),
                _buildModernTextField(
                  controller: _emailController,
                  label: 'Email (Read Only)',
                  icon: Icons.email_outlined,
                  enabled: false,
                  isDark: isDark,
                ),
                
                const SizedBox(height: 20),
                _buildModernTextField(
                  controller: _telController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                _buildModernDateField(isDark),
                
                const SizedBox(height: 40),
                
                _buildSectionHeader(
                  widget.role == 'Athlete' 
                      ? 'Location & Sports Info' 
                      : 'Location & Business Info',
                  Icons.location_on_outlined,
                  isDark,
                ),
                const SizedBox(height: 20),
                
                _buildModernDropdownField(
                  label: 'Province',
                  value: _editedData['province'],
                  items: _provinces,
                  onChanged: (value) => setState(() => _editedData['province'] = value),
                  icon: Icons.map_outlined,
                  isDark: isDark,
                ),
                
                const SizedBox(height: 20),
                _buildModernTextField(
                  controller: _cityController,
                  label: 'City',
                  icon: Icons.location_city_outlined,
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
                
                if (widget.role == 'Athlete') ...[
                  const SizedBox(height: 20),
                  _buildModernTextField(
                    controller: TextEditingController(text: _editedData['sport']),
                    label: 'Sport (Read Only)',
                    icon: Icons.sports_outlined,
                    enabled: false,
                    isDark: isDark,
                  ),
                  
                  const SizedBox(height: 20),
                  _buildModernTextField(
                    controller: _positionsController,
                    label: 'Position',
                    icon: Icons.sports_handball_outlined,
                    isDark: isDark,
                  ),
                  
                  const SizedBox(height: 20),
                  _buildModernDropdownField(
                    label: 'Gender',
                    value: _editedData['gender'],
                    items: _genders,
                    onChanged: (value) => setState(() => _editedData['gender'] = value),
                    icon: Icons.person_outline_rounded,
                    isDark: isDark,
                  ),
                  
                  const SizedBox(height: 20),
                  _buildModernDropdownField(
                    label: 'Institute',
                    value: _editedData['institute'],
                    items: _institutes,
                    onChanged: (value) => setState(() => _editedData['institute'] = value),
                    icon: Icons.school_outlined,
                    isDark: isDark,
                  ),
                  
                  const SizedBox(height: 20),
                  _buildModernTextField(
                    controller: _experienceController,
                    label: 'Experience (Years)',
                    icon: Icons.star_outline_rounded,
                    keyboardType: TextInputType.number,
                    isDark: isDark,
                  ),
                ],
                
                if (widget.role == 'Sponsor') ...[
                  const SizedBox(height: 20),
                  _buildModernDropdownField(
                    label: 'Organization Structure',
                    value: _editedData['orgStructure'],
                    items: _orgStructures,
                    onChanged: (value) => setState(() => _editedData['orgStructure'] = value),
                    icon: Icons.account_tree_outlined,
                    isDark: isDark,
                  ),
                  
                  const SizedBox(height: 20),
                  _buildModernDropdownField(
                    label: 'Sport of Interest',
                    value: _editedData['sportIntrested'] ?? _editedData['sportInterested'],
                    items: _popularSports,
                    onChanged: (value) => setState(() => _editedData['sportIntrested'] = value),
                    icon: Icons.sports_soccer_outlined,
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Sport of interest is required';
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(bool isDark) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFF667EEA),
                  width: 2,
                ),
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF667EEA),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF667EEA).withOpacity(0.2),
                const Color(0xFF764BA2).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF667EEA),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A202C),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool enabled = true,
    TextInputType? keyboardType,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1A202C),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: TextStyle(
            color: enabled 
                ? (isDark ? Colors.grey[400] : Colors.grey[600])
                : Colors.grey[500],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[400],
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: enabled
                  ? LinearGradient(
                      colors: [
                        const Color(0xFF667EEA).withOpacity(0.2),
                        const Color(0xFF764BA2).withOpacity(0.2),
                      ],
                    )
                  : null,
              color: enabled ? null : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: enabled ? const Color(0xFF667EEA) : Colors.grey,
              size: 18,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF667EEA),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE53E3E),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE53E3E),
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          filled: true,
          fillColor: enabled
              ? (isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF8FAFC))
              : (isDark ? Colors.grey[800] : Colors.grey[50]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator ?? (enabled ? (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        } : null),
      ),
    );
  }

  Widget _buildModernDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required bool isDark,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        onChanged: onChanged,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1A202C),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667EEA).withOpacity(0.2),
                  const Color(0xFF764BA2).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF667EEA),
              size: 18,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF667EEA),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE53E3E),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE53E3E),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator,
        dropdownColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1A202C),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildModernDateField(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        controller: _dateController,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1A202C),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667EEA).withOpacity(0.2),
                  const Color(0xFF764BA2).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF667EEA),
              size: 18,
            ),
          ),
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF667EEA),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE53E3E),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE53E3E),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Date of birth is required';
          }
          return null;
        },
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _editedData['date'] != null 
                ? DateTime.parse(_editedData['date'])
                : DateTime.now().subtract(Duration(days: 365 * 18)),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color(0xFF667EEA),
                    onPrimary: Colors.white,
                    surface: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                    onSurface: isDark ? Colors.white : const Color(0xFF1A202C),
                  ),
                  dialogBackgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            setState(() {
              _editedData['date'] = picked.toString().split(' ')[0];
              _dateController.text = _editedData['date'];
            });
          }
        },
      ),
    );
  }
}