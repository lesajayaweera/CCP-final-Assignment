import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/Services/PushNotifications.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_ignite/pages/Login.dart';

class Users {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // login method
  Future<String?> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) return null;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // 🔑 Generate a new session ID
      String sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('sessionId', sessionId);
      await prefs.setString('uid', user.uid);

      // Save session ID in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        "activeSession": sessionId,
        "lastLogin": FieldValue.serverTimestamp(),
      });

      await PushNotificationService.initialize();

      // Start listening for session changes
      _listenForSessionChanges(user.uid, sessionId, context);

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data() as Map<String, dynamic>;
        String role = data['role']?.toString() ?? '';
        if (role.isNotEmpty) {
          await prefs.setString('role', role); // cache role too
          return role;
        }
      }
      return null; // role missing or user not found
    } on FirebaseAuthException catch (e) {
      return "error:${e.message}";
    } catch (e) {
      return "error:$e";
    }
  }

  void _listenForSessionChanges(
    String uid,
    String localSessionId,
    BuildContext context,
  ) {
    _firestore.collection('users').doc(uid).snapshots().listen((doc) async {
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      String? currentSession = data['activeSession'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedSession = prefs.getString('sessionId');

      // If Firestore session != local session, logout
      if (currentSession != null && currentSession != storedSession) {
        await _auth.signOut();
        await prefs.clear();

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        }
      }
    });
  }

  //  get the user profile image
  Future<String?> getUserProfileImage(String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance
          .collection(role.toString().toLowerCase())
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.data()?['profile'] as String?;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserDetails(
    BuildContext context,
    String role,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        showSnackBar(context, "User not logged in.", Colors.red);
        return null;
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(role.toLowerCase().trim())
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        showSnackBar(
          context,
          "No athlete data found for this user.",
          Colors.red,
        );
        return null;
      }
    } on FirebaseException catch (e) {
      showSnackBar(
        context,
        "Error fetching athlete data: ${e.message}",
        Colors.red,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDetailsByUIDAndRole(
    BuildContext context,
    String uid,
    String role,
  ) async {
    try {
      String collectionName;

      switch (role.toLowerCase()) {
        case 'athlete':
          collectionName = 'athlete';
          break;
        case 'sponsor':
          collectionName = 'sponsor';
          break;
        default:
          throw Exception("Invalid role: $role");
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        showSnackBar(context, 'User not found', Colors.red);
        return null;
      }
    } catch (e) {
      showSnackBar(context, 'Error fetching user details: $e', Colors.red);
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getConnectedUsers() async {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) return [];

    List<Map<String, dynamic>> connectedUsers = [];

    try {
      // Get connections subcollection
      final connectionsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .collection('connections')
          .get();

      for (var connectionDoc in connectionsSnapshot.docs) {
        String connectedUid = connectionDoc.id;

        // Fetch the connected user's main profile
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(connectedUid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          String role = userData['role'] ?? '';

          Map<String, dynamic>? fullUserData;

          if (role == 'Athlete') {
            // Fetch from athlete collection
            final athleteDoc = await FirebaseFirestore.instance
                .collection('athlete')
                .doc(connectedUid)
                .get();
            if (athleteDoc.exists) {
              fullUserData = {'uid': connectedUid, ...athleteDoc.data()!};
            }
          } else {
            // Fetch from another role collection
            final otherDoc = await FirebaseFirestore.instance
                .collection(role.toLowerCase()) // e.g. "sponsor", "coach"
                .doc(connectedUid)
                .get();
            if (otherDoc.exists) {
              fullUserData = {'uid': connectedUid, ...otherDoc.data()!};
            }
          }

          if (fullUserData != null) {
            connectedUsers.add(fullUserData);
          }
        }
      }
    } catch (e) {
      print("Error fetching connected users: $e");
    }

    return connectedUsers;
  }

  static Future<Map<String, dynamic>?> getUserDetailsByUid(
    BuildContext context,
    String uid,
  ) async {
    try {
      // Step 1: Fetch the user document from 'users' collection to get the role
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        showSnackBar(context, 'User not found in users collection', Colors.red);
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final role = userData['role']?.toString().toLowerCase();
      print("Fetched role: $role");

      if (role == null || (role != 'athlete' && role != 'sponsor')) {
        showSnackBar(context, 'Invalid or missing role for user', Colors.red);
        return null;
      }

      // Step 2: Based on role, fetch details from respective collection
      String collectionName = role == 'athlete' ? 'athlete' : 'sponsor';

      DocumentSnapshot roleDoc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(uid)
          .get();

      if (roleDoc.exists) {
        // Combine data from 'users' collection and role-specific collection
        final roleData = roleDoc.data() as Map<String, dynamic>;

        return {
          'uid': uid,
          ...userData, // Base user details
          ...roleData, // Role-specific details
        };
      } else {
        showSnackBar(context, '$role details not found', Colors.red);
        return null;
      }
    } catch (e) {
      showSnackBar(context, 'Error fetching user details: $e', Colors.red);
      return null;
    }
  }

  static Future<void> logout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {
          "activeSession": null, // clear the session
        },
      );
    }

    // 🔐 Sign out the user
    await FirebaseAuth.instance.signOut();

    // Clear local storage if you’re using SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 🚪 Navigate to Login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false,
    );
  }
}
