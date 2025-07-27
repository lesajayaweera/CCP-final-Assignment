import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/home.dart';
import 'package:sport_ignite/pages/veiwAthletes.dart';
import 'package:sport_ignite/widget/common/appbar.dart';
import 'package:sport_ignite/widget/common/bottomNavigation.dart';

class Dashboard extends StatefulWidget {
  final String role;
  const Dashboard({super.key, required this.role});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> athleteScreens = [
      SocialFeedScreen(role: widget.role),
      Center(child: Text('Athlete My Network')),
      Center(child: Text('Athlete Post')),
      Center(child: Text('Athlete Shorts')),
      Center(child: Text('Athlete Sponsorships')),
    ];
    final List<Widget> sponsorScreens = [
      SocialFeedScreen(role: widget.role),
      Center(child: Text('My Network')),
      Center(child: Text('Post')),
      Center(child: Text('Shorts')),
      AthletesScreen(role: widget.role)
    ];

    final screens = widget.role == 'Athlete' ? athleteScreens : sponsorScreens;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: LinkedInAppBar(page: false, role: widget.role),
      body: screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        role: widget.role,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
