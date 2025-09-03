import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  static Future<List<Map<String, dynamic>>> searchAllUsers(String query) async {
    if (query.isEmpty) return [];

    try {
      // List to hold all results
      List<Map<String, dynamic>> allUsers = [];

      // Collections to search
      List<String> collections = ['user', 'athlete', 'sponsor'];

      // Convert query to lowercase for case-insensitive search
      String lowerQuery = query.toLowerCase();

      for (String collection in collections) {
        // First, get all documents from the collection
        final result = await FirebaseFirestore.instance
            .collection(collection)
            .get();

        // Filter on the client side for case-insensitive search
        for (var doc in result.docs) {
          Map<String, dynamic> data = doc.data();
          String name = (data['name'] ?? '').toString().toLowerCase();
          
          // Check if the name contains the search query (case-insensitive)
          if (name.contains(lowerQuery)) {
            data['collection'] = collection;
            data['id'] = doc.id; // Add document ID
            allUsers.add(data);
          }
        }
      }

      // Sort results by relevance (exact matches first, then partial matches)
      allUsers.sort((a, b) {
        String nameA = (a['name'] ?? '').toString().toLowerCase();
        String nameB = (b['name'] ?? '').toString().toLowerCase();
        
        // Exact matches first
        bool exactMatchA = nameA == lowerQuery;
        bool exactMatchB = nameB == lowerQuery;
        
        if (exactMatchA && !exactMatchB) return -1;
        if (!exactMatchA && exactMatchB) return 1;
        
        // Then by how early the match appears in the string
        int indexA = nameA.indexOf(lowerQuery);
        int indexB = nameB.indexOf(lowerQuery);
        
        if (indexA != indexB) return indexA.compareTo(indexB);
        
        // Finally by alphabetical order
        return nameA.compareTo(nameB);
      });

      return allUsers;
    } catch (e) {
      print("Error searching users: $e");
      return [];
    }
  }

  // Alternative method using Firestore's text search capabilities
  // Note: This requires setting up composite indexes and may have limitations
  static Future<List<Map<String, dynamic>>> searchAllUsersFirestore(String query) async {
    if (query.isEmpty) return [];

    try {
      List<Map<String, dynamic>> allUsers = [];
      List<String> collections = ['user', 'athlete', 'sponsor'];
      
      // Convert to lowercase for consistent searching
      String lowerQuery = query.toLowerCase();
      
      for (String collection in collections) {
        // Search using Firestore's range queries (case-sensitive limitation)
        final result = await FirebaseFirestore.instance
            .collection(collection)
            .where("name", isGreaterThanOrEqualTo: lowerQuery)
            .where("name", isLessThanOrEqualTo: lowerQuery + '\uf8ff')
            .get();

        allUsers.addAll(result.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          data['collection'] = collection;
          data['id'] = doc.id;
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