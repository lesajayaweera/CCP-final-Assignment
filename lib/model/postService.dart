import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a post (text + media) to Firestore
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

    // Build post data
    final postData = {
      'uid': user.uid,
      'text': text,
      'audience': audience,
      'timestamp': FieldValue.serverTimestamp(),
      'media': mediaUrls, // list of photo/video URLs
      'likes': 0,
      'comments': 0,
      'role': role,
      'sport': sport, // ✅ store sport in the post
    };

    // Save post in Firestore
    await _firestore.collection('posts').add(postData);
  }

  static Future<List<Map<String, dynamic>>> getPostsForUserSport(String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    // 🔹 Fetch current user's sport based on role
    String? userSport;
    if (role == 'Athlete') {
      final doc = await  FirebaseFirestore.instance.collection('athlete').doc(user.uid).get();
      userSport = doc.data()?['sport'];
    } else if (role == 'Sponsor') {
      final doc = await  FirebaseFirestore.instance.collection('sponsor').doc(user.uid).get();
      userSport = doc.data()?['sportIntrested'];
    }

    if (userSport == null) {
      throw Exception("User sport not found");
    }

    // 🔹 Query posts where audience == 'Anyone' AND sport == userSport
    final querySnapshot = await  FirebaseFirestore.instance
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
}
