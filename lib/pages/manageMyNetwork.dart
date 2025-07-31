import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
                title: 'Invitation',
                onTap: () => _navigateTo('invitation'),
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

  Widget _buildNavOption({required String title, required VoidCallback onTap}) {
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

  void _connectWithSponsor(Sponsor sponsor) {
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
  final Sponsor sponsor;
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
                      image: AssetImage(sponsor.imagePath),
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
                          image: AssetImage(sponsor.companyLogo),
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

class Sponsor {
  final String name;
  final String title;
  final String company;
  final String imagePath;
  final String companyLogo;

  Sponsor({
    required this.name,
    required this.title,
    required this.company,
    required this.imagePath,
    required this.companyLogo,
  });
}

// Sample data
List<Sponsor> sponsors = [
  Sponsor(
    name: 'Veronica Symo...',
    title: 'Scout in Company',
    company: 'Lomonosov Moscow State',
    imagePath: 'assets/images/veronica.jpg',
    companyLogo: 'assets/images/moscow_logo.png',
  ),
  Sponsor(
    name: 'Alexey Makovs...',
    title: 'Private Sponsor',
    company: 'LIVERPOOL Moscow State',
    imagePath: 'assets/images/alexey.jpg',
    companyLogo: 'assets/images/liverpool_logo.png',
  ),
  Sponsor(
    name: 'Michael Riley',
    title: 'Company Sponsor',
    company: 'Tech Corp',
    imagePath: 'assets/images/michael.jpg',
    companyLogo: 'assets/images/tech_logo.png',
  ),
  Sponsor(
    name: 'Daniel Jenkins',
    title: 'company sponsor',
    company: 'Sports Academy',
    imagePath: 'assets/images/daniel.jpg',
    companyLogo: 'assets/images/sports_logo.png',
  ),
];
