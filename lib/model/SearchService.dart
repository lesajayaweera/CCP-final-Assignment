import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService{

  static Future<List<Map<String, dynamic>>> searchAllUsers(String query) async {
    if (query.isEmpty) return [];

    try {
      // List to hold all results
      List<Map<String, dynamic>> allUsers = [];

      // Collections to search
      List<String> collections = ['user', 'athlete', 'sponsor'];

      for (String collection in collections) {
        final result = await FirebaseFirestore.instance
            .collection(collection)
            .where("name", isGreaterThanOrEqualTo: query)
            .where("name", isLessThanOrEqualTo: query + '\uf8ff')
            .get();

        allUsers.addAll(result.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          data['collection'] = collection; // optional: track source
          return data;
        }));
      }

      return allUsers;
    } catch (e) {
      print("Error searching users: $e");
      return [];
    }
  }
}