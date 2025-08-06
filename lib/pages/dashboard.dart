import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/home.dart';
import 'package:sport_ignite/pages/manageMyNetwork.dart';
import 'package:sport_ignite/pages/post_create.dart';
import 'package:sport_ignite/pages/shorts.dart';
import 'package:sport_ignite/pages/veiwAthletes.dart';
import 'package:sport_ignite/widget/common/appbar.dart';
import 'package:sport_ignite/widget/common/bottomNavigation.dart';


class Dashboard extends StatefulWidget {
  final String role;
  final int initialIndex;
  const Dashboard({super.key, required this.role, this.initialIndex = 0});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> athleteScreens = [
      SocialFeedScreen(role: widget.role),
      NetworkManagementScreen(role: widget.role),
      SocialFeedScreen(role: widget.role),
      ShortsPlayerScreen(),
      Center(child: Text('Athlete Sponsorships')),
    ];
    final List<Widget> sponsorScreens = [
      SocialFeedScreen(role: widget.role),
      NetworkManagementScreen(role:widget.role),
      SocialFeedScreen(role: widget.role),
      ShortsPlayerScreen(),
      AthletesScreen(role: widget.role),
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
          if(index ==2){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SharePostScreen(),
              ),
            ).then((value) {
              // Refresh the current screen after creating a post
              setState(() {});
            });
          }
          else{
            setState(() {
              _currentIndex =index;
              
            });
          }
         
        },
      ),
    );
  }
}
