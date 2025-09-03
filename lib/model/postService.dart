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

  // Future<void> createPost({
  //   required String text,
  //   required String audience,
  //   required List<XFile> mediaFiles,
  //   required String role,
  // }) async {
  //   final user = _auth.currentUser;
  //   if (user == null) {
  //     throw Exception("User not logged in");
  //   }

  //   // Upload media and get URLs
  //   List<String> mediaUrls = [];
  //   for (var file in mediaFiles) {
  //     final ref = _storage
  //         .ref()
  //         .child('posts')
  //         .child(user.uid)
  //         .child('${DateTime.now().millisecondsSinceEpoch}_${file.name}');

  //     await ref.putFile(File(file.path));
  //     final url = await ref.getDownloadURL();
  //     mediaUrls.add(url);
  //   }

  //   // 🔹 Fetch user's sport based on role
  //   String? sport;
  //   if (role == 'Athlete') {
  //     final doc = await _firestore.collection('athlete').doc(user.uid).get();
  //     sport = doc.data()?['sport'];
  //   } else if (role == 'Sponsor') {
  //     final doc = await _firestore.collection('sponsor').doc(user.uid).get();
  //     sport = doc.data()?['sportIntrested'];
  //   }

  //   // 🔹 Create document reference first
  //   final docRef = _firestore.collection('posts').doc();
  //   final postId = docRef.id; // ✅ Firestore-generated unique ID

  //   // Build post data
  //   final postData = {
  //     'pid': postId, // ✅ store the generated ID
  //     'uid': user.uid,
  //     'text': text,
  //     'audience': audience,
  //     'timestamp': FieldValue.serverTimestamp(),
  //     'media': mediaUrls,
  //     'likes': 0,
  //     'comments': 0,
  //     'role': role,
  //     'sport': sport,
  //   };

  //   // Save post in Firestore
  //   await docRef.set(postData);
  // }

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
    List<String> mediaTypes = []; // track each uploaded file type

    for (var file in mediaFiles) {
      final ref = _storage
          .ref()
          .child('posts')
          .child(user.uid)
          .child('${DateTime.now().millisecondsSinceEpoch}_${file.name}');

      await ref.putFile(File(file.path));
      final url = await ref.getDownloadURL();
      mediaUrls.add(url);

      // detect file type by extension
      final ext = file.path.toLowerCase();
      if (ext.endsWith('.mp4') ||
          ext.endsWith('.mov') ||
          ext.endsWith('.avi') ||
          ext.endsWith('.mkv')) {
        mediaTypes.add("video");
      } else if (ext.endsWith('.jpg') ||
          ext.endsWith('.jpeg') ||
          ext.endsWith('.png') ||
          ext.endsWith('.gif') ||
          ext.endsWith('.webp')) {
        mediaTypes.add("photo");
      } else {
        mediaTypes.add("unknown");
      }
    }

    // 🔹 Decide overall postType
    String postType;
    if (mediaFiles.isEmpty) {
      postType = "text";
    } else {
      final uniqueTypes = mediaTypes.toSet();
      if (uniqueTypes.length == 1) {
        postType = uniqueTypes.first; // photo OR video
      } else {
        postType = "mixed"; // if both photo + video
      }
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
      'postType': postType, // ✅ new field
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

  static Future<void> addLike({
    required String postId,
    required BuildContext context,
  }) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    // Get user data
    final Map<String, dynamic>? userdata = await Users.getUserDetailsByUid(
      context,
      uid,
    );

    final likeRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid); // Use uid as doc ID to prevent duplicate likes

    final docSnapshot = await likeRef.get();

    if (docSnapshot.exists) {
      // If user already liked -> Remove like (toggle)
      await likeRef.delete();
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(-1),
      });
    } else {
      // Add like
      await likeRef.set({
        'uid': uid,
        'username': userdata?['name'],
        'userRole': userdata?['role'],
        'userAvatar': userdata?['profile'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Increment like count
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(1),
      });
    }
  }

  static Future<List<Map<String, dynamic>>> getVideoPosts(
    BuildContext context,
  ) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      // Filter only video posts
      final videoPosts = querySnapshot.docs.where((doc) {
        final data = doc.data();
        if (data['media'] == null || (data['media'] as List).isEmpty) {
          return false;
        }
        return (data['media'] as List).any((url) {
          final lower = url.toString().toLowerCase();
          return lower.contains('.mp4') ||
              lower.contains('.mov') ||
              lower.contains('.avi') ||
              lower.contains('.mkv');
        });
      }).toList();

      // Now enrich posts with user details
      List<Map<String, dynamic>> enrichedPosts = [];

      for (var doc in videoPosts) {
        final postData = doc.data();
        postData['id'] = doc.id;

        // Fetch user details by uid + role
        final userDetails = await Users().getUserDetailsByUIDAndRole(
          context,
          postData['uid'],
          postData['role'],
        );

        // Attach user details to post
        if (userDetails != null) {
          postData['user'] = userDetails; // 👈 add a "user" field
        }

        enrichedPosts.add(postData);
      }

      print("Video Posts with User Details: $enrichedPosts");

      return enrichedPosts;
    } catch (e) {
      print("Error fetching video posts: $e");
      return [];
    }
  }

  Future<bool> checkIfUserLikedPost(String postId) async {
    try {
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUid == null) return false;

      final likeDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(currentUserUid!)
          .get();

      return likeDoc.exists;
    } catch (e) {
      print('Error checking like status for post $postId: $e');
      return false;
    }
  }
}
