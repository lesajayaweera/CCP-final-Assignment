import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/manageMyNetwork.dart';

class InvitationsScreen extends StatelessWidget {
  final List<InvitationRequest> invitations;
  final Function(String) onAccept;
  final Function(String) onIgnore;

  const InvitationsScreen({
    Key? key,
    required this.invitations,
    required this.onAccept,
    required this.onIgnore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        actions: [
          TextButton(
            onPressed: () {
              // Optional: implement see all
            },
            child: const Text(
              'See all',
              style: TextStyle(
                color: Color(0xFF0A66C2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: invitations.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                final invitation = invitations[index];
                return InvitationCard(
                  invitation: invitation,
                  onAccept: () => onAccept(invitation.id),
                  onIgnore: () => onIgnore(invitation.id),
                );
              },
            ),
    );
  }
}
