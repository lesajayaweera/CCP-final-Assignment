import 'package:cloud_firestore/cloud_firestore.dart';

class Athletes {
  final String uid;
  final String name;
  final String sport;
  final String club;
  final String imagePath;

  Athletes({
    required this.uid,
    required this.name,
    required this.sport,
    required this.club,
    required this.imagePath,
  });

  factory Athletes.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    if (data['role'] == 'Athlete') {
      return Athletes(
        uid: doc.id,
        name: data['name'] ?? '',
        sport: data['sport'] ?? '',
        club: data['institute'] ?? '',
        imagePath: data['profile'] ?? '',
      );
    } else {
      return Athletes(
        uid: doc.id,
        name: data['name'] ?? '',
        sport: data['sportIntrested'] ?? '',
        club: data['company'] ?? '',
        imagePath: data['profile'] ?? '',
      );
    }
  }
}
