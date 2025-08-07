import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/model/ConnectionService.dart';
import 'package:sport_ignite/model/Sponsor.dart';
import 'package:sport_ignite/model/userCardData.dart';
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

class AthleteCard extends StatefulWidget {
  final Athletes athlete;

  const AthleteCard({Key? key, required this.athlete}) : super(key: key);

  @override
  State<AthleteCard> createState() => _AthleteCardState();
}

class _AthleteCardState extends State<AthleteCard> {
  String _connectionStatus = 'loading'; // 'loading', 'none', 'pending'

  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
  }

  Future<void> _checkConnectionStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final hasSent = await ConnectionService.hasSentRequest(
      currentUser.uid,
      widget.athlete.uid,
    );

    if (mounted) {
      setState(() {
        _connectionStatus = hasSent ? 'pending' : 'none';
      });
    }
  }

  Future<void> _handleSendRequest() async {
    await ConnectionService.sendConnectionRequestUsingUID(
      context,
      widget.athlete.uid,
    );
    setState(() {
      _connectionStatus = 'pending';
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileView(role: 'Athlete', uid: widget.athlete.uid),
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
                children: [
                  // Profile Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.athlete.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Name
                  Text(
                    widget.athlete.name,
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

                  // Sport
                  Text(
                    widget.athlete.sport,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),

                  // Club
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.athlete.club,
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[600]),
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
                      onPressed: _connectionStatus == 'pending'
                          ? null
                          : _handleSendRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _connectionStatus == 'pending'
                            ? Colors.grey
                            : Colors.white,
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[700]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      child: Text(
                        _connectionStatus == 'pending' ? 'Pending' : 'Connect',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Close button (optional functionality)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  // Optional remove from list
                },
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.close, color: Colors.white, size: 14),
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
