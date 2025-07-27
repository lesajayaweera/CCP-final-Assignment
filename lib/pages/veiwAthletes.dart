import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/Sponsor.dart';
import 'package:sport_ignite/model/userData.dart';
import 'package:sport_ignite/pages/profileView.dart';

class AthletesScreen extends StatefulWidget {
  final String role;
  // final bool fromProfile;
  const AthletesScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  List<Athletes> verifiedAthletes = [];
  List<String> verifiedUids = [];

  @override
  void initState() {
    super.initState();
    fetchVerifiedAthletes();
  }

  void fetchVerifiedAthletes() async {
    final uids = await Sponsor.getUidsWithApprovedCertificates();

    if (!mounted) return; // to avoid setState after widget disposed

    final List<Athletes> fetchedAthletes = [];

    for (final uid in uids) {
      final doc = await FirebaseFirestore.instance
          .collection('athlete')
          .doc(uid)
          .get();
      if (doc.exists) {
        fetchedAthletes.add(Athletes.fromFirestore(doc));
      }
    }

    setState(() {
      verifiedUids = uids;
      verifiedAthletes = fetchedAthletes;
    });

    print('Verified UIDs: $uids');
    print('Fetched Athletes Count: ${fetchedAthletes.length}');
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (verifiedAthletes.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Athletes you May Know'),
          ),

        Expanded(
          child: verifiedAthletes.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: verifiedAthletes.length,
                    itemBuilder: (context, index) {
                      return AthleteCard(athlete: verifiedAthletes[index]);
                    },
                  ),
                )
              : const Center(child: Text('No Verified Athletes at the moment')),
        ),
      ],
    );
  }
}

class AthleteCard extends StatelessWidget {
  final Athletes athlete;

  const AthleteCard({Key? key, required this.athlete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileView(role: 'Athlete', uid: athlete.uid),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Profile Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(athlete.imagePath),
                        // image: AssetImage(athlete.imagePath), // Use this if you have local images
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
      
                  // Name
                  Text(
                    athlete.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
      
                  // Sport/Position
                  Text(
                    athlete.sport,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
      
                  // Club/Team info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: 18,
                      //   height: 18,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     image: DecorationImage(
                      //       image: AssetImage(athlete.clubLogo),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          athlete.club,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
      
                  // Connect Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Connected with ${athlete.name}'),
                        //     duration: const Duration(seconds: 2),
                        //   ),
                        // );
                        showSnackBar(
                          context,
                          'Connected with ${athlete.name}',
                          Colors.green,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[700]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      child: const Text(
                        'Connect',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            // Close button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  // Optional: add remove logic
                },
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sample data
