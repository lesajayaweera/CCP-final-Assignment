import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  /// Step 1: Get all verified athlete UIDs
  static Future<Set<String>> getVerifiedAthleteUids() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('certificates')
          .where('status', isEqualTo: 'true')
          .get();

      final Set<String> uids = {};
      for (var doc in querySnapshot.docs) {
        final uid = doc.reference.parent.parent?.id;
        if (uid != null) {
          uids.add(uid);
        }
      }
      return uids;
    } catch (e) {
      return {};
    }
  }

  /// Step 2: Get athlete details from the athlete collection
  static Future<List<Map<String, dynamic>>> getVerifiedAthletes() async {
    final uids = await getVerifiedAthleteUids();

    final List<Map<String, dynamic>> athletes = [];
    for (final uid in uids) {
      final doc = await FirebaseFirestore.instance
          .collection('athlete')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        data["uid"] = uid;
        athletes.add(data);
      }
    }
    return athletes;
  }

  /// Step 3: Load stats using sport + email
  static Future<Map<String, dynamic>?> loadUserStats(
    String sport,
    String email,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user_stats')
          .doc(sport)
          .collection('athletes')
          .doc(email)
          .get();

      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      return null;
    }
  }

  /// Step 4: Calculate score per sport
  static double calculateScore(String sport, Map<String, dynamic> stats) {
    switch (sport.toLowerCase()) {
      case "basketball":
        return (stats["Points"] ?? 0) * 1.0 +
            (stats["Assists"] ?? 0) * 0.5 +
            (stats["Rebounds"] ?? 0) * 0.5;
      case "cricket":
        return (stats["Runs"] ?? 0) * 1.0 +
            (stats["BattingAverage"] ?? 0) * 2.0 +
            (stats["StrikeRate"] ?? 0) * 0.5;
      case "football":
        return (stats["Goals"] ?? 0) * 2.0 +
            (stats["Assists"] ?? 0) * 1.5 +
            (stats["PassAccuracy"] ?? 0) * 0.2;
      default:
        return 0.0;
    }
  }

  /// Step 5: Build leaderboard
  static Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final verifiedAthletes = await getVerifiedAthletes();

    final List<Map<String, dynamic>> allAthletes = [];

    for (final athlete in verifiedAthletes) {
      final String sport =
          athlete["sport"]; // 👈 take sport directly from athlete collection
      final String email = athlete["email"];

      // Load stats using sport + email
      final stats = await loadUserStats(sport, email);

      if (stats != null) {
        final score = calculateScore(sport, stats);

        // Merge athlete details + stats + score
        final Map<String, dynamic> mergedData = {
          ...athlete, // all athlete fields (name, age, country, etc.)
          "stats": stats,
          "score": score,
        };

        allAthletes.add(mergedData);
      }
    }

    // Sort by score (highest first)
    allAthletes.sort((a, b) => (b["score"]).compareTo(a["score"]));

    return allAthletes;
  }
}
