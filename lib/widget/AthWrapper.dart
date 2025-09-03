 

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_ignite/pages/Login.dart';
import 'package:sport_ignite/pages/dashboard.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

// class _WrapperState extends State<Wrapper> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateUser();
//   }

//   Future<void> _navigateUser() async {
//     // This delay ensures the splash screen is visible for a moment.
//     await Future.delayed(const Duration(seconds: 3));

//     // This check is important to prevent errors if the user navigates away
//     // while this function is running.
//     if (!mounted) return;

//     // Check the current user's authentication state.
//     final user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       // User is signed in.
//       final prefs = await SharedPreferences.getInstance();
//       final role = prefs.getString('role');

//       if (role != null && role.isNotEmpty) {
//         // If the role is cached, navigate to the dashboard.
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => Dashboard(role: role)),
//         );
//       } else {
//         // If role is missing for some reason, default to login.
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const Login()),
//         );
//       }
//     } else {
//       // User is not signed in, navigate to the login screen.
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const Login()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This is the UI that will be displayed while the logic in _navigateUser runs.
//     // It's your splash screen.
//     return Scaffold(
//       body: Container(
//         // Using a gradient for a professional look, consistent with your app's theme.
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF8b5fbf)],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Your App Logo. Ensure the path in pubspec.yaml and here is correct.
//               Image.asset('asset/image/Logo.png', width: 120),
//               const SizedBox(height: 24),

//               // Optional: App Name for branding.
//               const Text(
//                 'Sport Ignite',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 48),

//               // A loading indicator to show that the app is working.
//               const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class _WrapperState extends State<Wrapper> {
  StreamSubscription? _sessionSub;

  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    super.dispose();
  }

  Future<void> _navigateUser() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role');
      final sessionId = prefs.getString('sessionId');

      if (role != null && role.isNotEmpty && sessionId != null) {
        // ✅ Start listening for session validity
        _listenForSessionChanges(user.uid, sessionId);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard(role: role)),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  void _listenForSessionChanges(String uid, String localSessionId) {
    _sessionSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) async {
      if (!doc.exists) return;
      final data = doc.data() as Map<String, dynamic>;
      final serverSession = data['activeSession'];

      final prefs = await SharedPreferences.getInstance();
      final storedSession = prefs.getString('sessionId');

      if (serverSession != null && serverSession != storedSession) {
        // 🚪 Session mismatch → force logout
        await FirebaseAuth.instance.signOut();
        await prefs.clear();

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF8b5fbf)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('asset/image/Logo.png', width: 120),
              const SizedBox(height: 24),
              const Text(
                'Sport Ignite',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

