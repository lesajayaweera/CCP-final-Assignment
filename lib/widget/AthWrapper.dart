import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/Login.dart';
import 'package:sport_ignite/pages/dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Widget _buildLoader() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/image/Logo.png', width: 100, height: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Loading user...");
          print(snapshot.data?.uid);
          return _buildLoader();
          
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in → check role
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                print("Loading user role...");
                print(roleSnapshot);
                return _buildLoader();
              }

              if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
                final data =
                    roleSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                final role = (data['role'] ?? '').toString();

                if (role.isEmpty) {
                  FirebaseAuth.instance.signOut();
                  return const Login();
                }

                return Dashboard(role: role);
              }

              // If no data → force logout
              FirebaseAuth.instance.signOut();
              return const Login();
            },
          );
        }

        // Not logged in
        return const Login();
      },
    );
  }
}
