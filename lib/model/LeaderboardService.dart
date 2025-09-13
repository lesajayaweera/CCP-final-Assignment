import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      // -------------------- BASKETBALL --------------------
      case "basketball":
        return (stats["Points"] ?? 0) * 1.0 + // scoring
            (stats["Assists"] ?? 0) * 0.9 + // playmaking
            (stats["Rebounds"] ?? 0) * 0.8 + // possession
            (stats["Steals"] ?? 0) * 1.2 + // defense
            (stats["Blocks"] ?? 0) * 1.2 + // defense
            ((stats["FieldGoalPercentage"] ?? 0) * 0.2) + // efficiency bonus
            ((stats["FreeThrowPercentage"] ?? 0) * 0.1) +
            ((stats["ThreePointPercentage"] ?? 0) * 0.2) -
            (stats["Turnovers"] ?? 0) * 1.5; // penalize mistakes

      // -------------------- CRICKET --------------------
      case "cricket":
        return (stats["Runs"] ?? 0) * 0.25 + // main contribution
            (stats["BattingAverage"] ?? 0) * 2.0 + // consistency
            (stats["StrikeRate"] ?? 0) * 0.4 + // attacking play
            (stats["Hundreds"] ?? 0) * 20 + // milestone bonus
            (stats["Fifties"] ?? 0) * 10 + // milestone bonus
            (stats["Wickets"] ?? 0) * 10 + // bowling impact
            (stats["Catches"] ?? 0) * 3 + // fielding
            (stats["RunOuts"] ?? 0) * 2 +
            ((100 - (stats["EconomyRate"] ?? 0)) *
                1.5); // lower economy = better

      // -------------------- FOOTBALL --------------------
      case "football":
        return (stats["Goals"] ?? 0) * 30 + // most impactful
            (stats["Assists"] ?? 0) * 20 + // playmaking
            (stats["PassAccuracy"] ?? 0) * 0.4 + // efficiency
            (stats["Tackles"] ?? 0) * 1.5 + // defensive contribution
            (stats["DuelsWon"] ?? 0) * 0.5 + // physical presence
            (stats["Touches"] ?? 0) * 0.1 + // involvement
            (stats["MinutesPlayed"] ?? 0) * 0.05 - // experience/time
            (stats["FoulsCommitted"] ?? 0) * 1.0 - // negative impact
            (stats["YellowCards"] ?? 0) * 5 -
            (stats["RedCards"] ?? 0) * 15; // harsher penalty

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



   static Future<String> getUserPreferredSport() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('sponsor')
        .doc(uid)
        .get();

    return doc.data()?['sportIntrested'] ?? 'All Sports';
  }

  static Future<void> saveUserPreferredSport(String sport) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'sportIntrested': sport});
  }
}
