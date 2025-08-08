import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/manageInvititations.dart';
// TODO :Need to do the Connection invitiation and Rejections 
class NetworkManagementScreen extends StatefulWidget {
  final String role;
  const NetworkManagementScreen({Key? key, required this.role})
    : super(key: key);

  @override
  State<NetworkManagementScreen> createState() =>
      _NetworkManagementScreenState();
}

class _NetworkManagementScreenState extends State<NetworkManagementScreen> {
  int selectedBottomNavIndex = 1; // My Network tab selected
  String currentView = 'network'; // 'network' or 'invitations'

  List<InvitationRequest> invitations = [
    InvitationRequest(
      id: '1',
      profileImage:
          'https://images.unsplash.com/photo-1494790108755-2616b332c5cd?w=150&h=150&fit=crop&crop=face',
      name: 'Sarah Johnson',
      title: 'Senior Software Engineer at Google',
      mutualConnections: 12,
      timeAgo: '1 week ago',
      message: 'I\'d love to connect with you!',
    ),
    InvitationRequest(
      id: '2',
      profileImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      name: 'Michael Chen',
      title: 'Product Manager at Microsoft',
      mutualConnections: 5,
      timeAgo: '3 days ago',
      message: 'Let\'s connect and share insights about product development.',
    ),
    InvitationRequest(
      id: '3',
      profileImage:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      name: 'Emily Rodriguez',
      title: 'UX Designer at Adobe',
      mutualConnections: 8,
      timeAgo: '5 days ago',
      message: null,
    ),
    InvitationRequest(
      id: '4',
      profileImage:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      name: 'David Kumar',
      title: 'Data Scientist at Netflix',
      mutualConnections: 3,
      timeAgo: '1 day ago',
      message:
          'Hi! I noticed we work in similar fields. Would love to connect.',
    ),
  ];


  // Sample data
List<SponsorCardDetails> sponsors = [
  SponsorCardDetails(
    name: 'Veronica Symo...',
    title: 'Scout in Company',
    company: 'Lomonosov Moscow State',
    imagePath:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
    companyLogo:
        'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=50&h=50&fit=crop',
  ),
  SponsorCardDetails(
    name: 'Alexey Makovs...',
    title: 'Private Sponsor',
    company: 'LIVERPOOL Moscow State',
    imagePath:
        'https://images.unsplash.com/photo-1566492031773-4f4e44671d66?w=150&h=150&fit=crop&crop=face',
    companyLogo:
        'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50&h=50&fit=crop',
  ),
  SponsorCardDetails(
    name: 'Michael Riley',
    title: 'Company Sponsor',
    company: 'Tech Corp',
    imagePath:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
    companyLogo:
        'https://images.unsplash.com/photo-1560472355-536de3962603?w=50&h=50&fit=crop',
  ),
  SponsorCardDetails(
    name: 'Daniel Jenkins',
    title: 'company sponsor',
    company: 'Sports Academy',
    imagePath:
        'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&h=150&fit=crop&crop=face',
    companyLogo:
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=50&h=50&fit=crop',
  ),
];


  @override
  Widget build(BuildContext context) {
    if (currentView == 'invitations') {
      return _buildInvitationsView();
    }

    return _buildNetworkView();
  }

  Widget _buildNetworkView() {
    return Column(
      children: [
        // Top navigation options
        Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildNavOption(
                title: 'Manage my network',
                onTap: () => _navigateTo('manage_network'),
              ),
              const Divider(height: 1),
              _buildNavOption(
                title: 'Invitation requests ',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> InvitationsScreen(onAccept: _handleAccept, onIgnore: _handleIgnore)),
                  );
                },
                hasNotification: invitations.isNotEmpty,
              ),

              const Divider(height: 1),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Sponsors section
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${widget.role} You may know',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: sponsors.length,
                    itemBuilder: (context, index) {
                      return SponsorCard(
                        sponsor: sponsors[index],
                        onConnect: () => _connectWithSponsor(sponsors[index]),
                        onDismiss: () => _dismissSponsor(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationsView() {
    return Scaffold(
      backgroundColor: Color(0xFFF3F2EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Manage invitations',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() => currentView = 'network'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle "See all" action
            },
            child: Text(
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
                  SizedBox(height: 16),
                  Text(
                    'No pending invitations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'When people send you invitations to connect,\nthey\'ll appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                return InvitationCard(
                  invitation: invitations[index],
                  onAccept: () => _handleAccept(invitations[index].id),
                  onIgnore: () => _handleIgnore(invitations[index].id),
                );
              },
            ),
    );
  }

  Widget _buildNavOption({
    required String title,
    required VoidCallback onTap,
    bool hasNotification = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasNotification)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: 8),
              ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  void _navigateTo(String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to $route'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _connectWithSponsor(SponsorCardDetails sponsor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connected with ${sponsor.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _dismissSponsor(int index) {
    setState(() {
      sponsors.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sponsor dismissed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleAccept(String invitationId) {
    setState(() {
      invitations.removeWhere((invitation) => invitation.id == invitationId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invitation accepted'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleIgnore(String invitationId) {
    setState(() {
      invitations.removeWhere((invitation) => invitation.id == invitationId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invitation ignored'),
        backgroundColor: Colors.grey[600],
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMessageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('New Connection'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Message'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}


class SponsorCard extends StatelessWidget {
  final SponsorCardDetails sponsor;
  final VoidCallback onConnect;
  final VoidCallback onDismiss;

  const SponsorCard({
    Key? key,
    required this.sponsor,
    required this.onConnect,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Profile Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(sponsor.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Name
                Text(
                  sponsor.name,
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

                // Title
                Text(
                  sponsor.title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Company info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(sponsor.companyLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        sponsor.company,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Connect Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onConnect,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: Text(
                      'Connect',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dismiss button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onDismiss,
              child: Container(
                width: 24,
                height: 24,
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
    );
  }
}


class SponsorCardDetails {
  final String name;
  final String title;
  final String company;
  final String imagePath;
  final String companyLogo;

  SponsorCardDetails({
    required this.name,
    required this.title,
    required this.company,
    required this.imagePath,
    required this.companyLogo,
  });
}

