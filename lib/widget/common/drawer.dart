import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/profile.dart';

class LinkedInDrawer extends StatelessWidget {
  final String role;

  const LinkedInDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                const SizedBox(height: 10),
                Text(
                  role, // show user role
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(role: role),
                ),
              );
            },
          ),
          if (role == "Athlete") ...[
            ListTile(
              leading: const Icon(Icons.sports),
              title: const Text('My Trainings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to athlete-specific page
              },
            ),
          ] else if (role == "Sponsor") ...[
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Sponsorship Deals'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to sponsor-specific page
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              // handle logout logic
            },
          ),
        ],
      ),
    );
  }
}
