import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/EditProfile.dart';
import 'package:sport_ignite/pages/Login.dart';

class SettingsScreen extends StatelessWidget {
  final String role;
  const SettingsScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black87),
            onPressed: () {
              // Handle help action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with globe icon and title
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.public,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Main settings options
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.person_outline,
                      title: 'Account preferences',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  EditProfilePage(uid: FirebaseAuth.instance.currentUser!.uid, role:role),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.lock_outline,
                      title: 'Sign in & security',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.visibility_outlined,
                      title: 'Visibility',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.shield_outlined,
                      title: 'Data privacy',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.business_center_outlined,
                      title: 'Advertising data',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Footer links
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFooterLink('Help Center', () {}),
                  const SizedBox(height: 16),
                  _buildFooterLink('Professional Community Policies', () {}),
                  const SizedBox(height: 16),
                  _buildFooterLink('Privacy Policy', () {}),
                  const SizedBox(height: 16),
                  _buildFooterLink('Accessibility', () {}),
                  const SizedBox(height: 16),
                  _buildFooterLink('Recommendation Transparency', () {}),
                  const SizedBox(height: 16),
                  _buildFooterLink('User Agreement', () {}),
                  const SizedBox(height: 16),
                  _buildFooterLink('End User License Agreement', () {}),
                  const SizedBox(height: 24),
                  _buildFooterLink('Sign Out', () async {
                    await FirebaseAuth.instance
                        .signOut(); // 🔐 Sign out the user

                    // Optional: Navigate to Login page or close the app
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false,
                    );
                    // Handle sign out
                  }, isSignOut: true),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 54),
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildFooterLink(
    String title,
    VoidCallback onTap, {
    bool isSignOut = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isSignOut ? Colors.red.shade600 : Colors.blue.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Usage example:
