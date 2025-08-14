import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/profileView.dart';
import 'package:sport_ignite/model/ConnectionService.dart';
class InvitationsScreen extends StatelessWidget {


  const InvitationsScreen({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    final String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (myUid.isEmpty) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Manage invitations',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('connection_requests')
            .where('receiverUID', isEqualTo: myUid) 
            .where('status', isEqualTo: 'pending')
            //.orderBy('timestamp', descending: true) // comment out for test
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('no data');
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) return _buildEmptyState();

          return FutureBuilder<List<InvitationRequest>>(
            future: _enrichInvitations(requests),
            builder: (context, enrichedSnapshot) {
              if (!enrichedSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final invitations = enrichedSnapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: invitations.length,
                itemBuilder: (context, index) {
                  final invitation = invitations[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(role: invitation.role,
        uid: invitation.uid,)));
                    },
                    child: InvitationCard(
                      invitation: invitation,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No pending invitations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When people send you invitations to connect,\nthey\'ll appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Future<List<InvitationRequest>> _enrichInvitations(
  List<QueryDocumentSnapshot> docs,
) async {
  List<Future<InvitationRequest>> futures = docs.map((doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final senderUID = data['senderUID'];
    final timestamp = data['timestamp'] as Timestamp;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('sponsor')
        .doc(senderUID)
        .get();

    String name = "";
    String title = "";
    String profileImage = "";
    String role = "";

    if (userDoc.exists) {
      final user = userDoc.data() as Map<String, dynamic>;
      name = user['name'];
      title = '${user['sportIntrested']} Sponsor';
      profileImage = user['profile'];
      role = "sponsor";
    } else {
      userDoc = await FirebaseFirestore.instance
          .collection('athlete')
          .doc(senderUID)
          .get();

      if (userDoc.exists) {
        final user = userDoc.data() as Map<String, dynamic>;
        name = user['name'];
        title = '${user['sport']} Athlete';
        profileImage = user['profile'];
        role = "athlete";
      }
    }

    return InvitationRequest(
      id: doc.id,
      uid: senderUID,
      role: role,
      profileImage: profileImage,
      name: name,
      title: title,
      mutualConnections: 0,
      timeAgo: _formatTimestamp(timestamp),
      message: null,
    );
  }).toList();

  return Future.wait(futures);
}


  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp.toDate());

    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

class InvitationRequest {
  final String id;
  final String profileImage;
  final String uid; // <-- Add this
  final String role; 
  final String name;
  final String title;
  final int mutualConnections;
  final String timeAgo;
  final String? message;

  InvitationRequest({
    required this.id,
    required this.uid, 
    required this.role,
    required this.profileImage,
    required this.name,
    required this.title,
    required this.mutualConnections,
    required this.timeAgo,
    this.message,
  });
}

class InvitationCard extends StatelessWidget {
  final InvitationRequest invitation;
  

  const InvitationCard({
    super.key,
    required this.invitation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(invitation.profileImage),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            invitation.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          invitation.timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invitation.title,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${invitation.mutualConnections} mutual connections',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (invitation.message != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F2EF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                invitation.message!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: (){},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'Ignore',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: (){
                    ConnectionService.acceptConnectionRequest(
                      invitation.id,
                      invitation.uid,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A66C2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
