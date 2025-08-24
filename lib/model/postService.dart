import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_ignite/model/User.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createPost({
    required String text,
    required String audience,
    required List<XFile> mediaFiles,
    required String role,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    // Upload media and get URLs
    List<String> mediaUrls = [];
    for (var file in mediaFiles) {
      final ref = _storage
          .ref()
          .child('posts')
          .child(user.uid)
          .child('${DateTime.now().millisecondsSinceEpoch}_${file.name}');

      await ref.putFile(File(file.path));
      final url = await ref.getDownloadURL();
      mediaUrls.add(url);
    }

    // 🔹 Fetch user's sport based on role
    String? sport;
    if (role == 'Athlete') {
      final doc = await _firestore.collection('athlete').doc(user.uid).get();
      sport = doc.data()?['sport'];
    } else if (role == 'Sponsor') {
      final doc = await _firestore.collection('sponsor').doc(user.uid).get();
      sport = doc.data()?['sportIntrested'];
    }

    // 🔹 Create document reference first
    final docRef = _firestore.collection('posts').doc();
    final postId = docRef.id; // ✅ Firestore-generated unique ID

    // Build post data
    final postData = {
      'pid': postId, // ✅ store the generated ID
      'uid': user.uid,
      'text': text,
      'audience': audience,
      'timestamp': FieldValue.serverTimestamp(),
      'media': mediaUrls,
      'likes': 0,
      'comments': 0,
      'role': role,
      'sport': sport,
    };

    // Save post in Firestore
    await docRef.set(postData);
  }

  static Future<List<Map<String, dynamic>>> getPostsForUserSport(
    String role,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    // 🔹 Fetch current user's sport based on role
    String? userSport;
    if (role == 'Athlete') {
      final doc = await FirebaseFirestore.instance
          .collection('athlete')
          .doc(user.uid)
          .get();
      userSport = doc.data()?['sport'];
    } else if (role == 'Sponsor') {
      final doc = await FirebaseFirestore.instance
          .collection('sponsor')
          .doc(user.uid)
          .get();
      userSport = doc.data()?['sportIntrested'];
    }

    if (userSport == null) {
      throw Exception("User sport not found");
    }

    // 🔹 Query posts where audience == 'Anyone' AND sport == userSport
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('audience', isEqualTo: 'Anyone')
        .where('sport', isEqualTo: userSport)
        .orderBy('timestamp', descending: true) // optional: newest first
        .get();

    // 🔹 Convert to List<Map<String, dynamic>>
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  static Future<void> addComment({
    required String postId,
    required String commentText,

    required BuildContext context,
  }) async {
    final commentId = FirebaseFirestore.instance.collection('unique').doc().id;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final Map<String, dynamic>? userdata = await Users.getUserDetailsByUid(
      context,
      uid,
    );

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set({
          'uid': uid,
          'username': userdata?['name'],
          'text': commentText,
          'userRole': userdata?['role'],
          'userAvatar': userdata?['profile'],
          'timestamp': FieldValue.serverTimestamp(),
        });

    // Optionally update the comment count in post
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'comments': FieldValue.increment(1),
    });
  }
}
