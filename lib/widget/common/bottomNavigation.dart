import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  late final List<NavBarItem> items;
  final String role;

  CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.role,
    required this.onTap,
  }) {
    if (role == 'Athlete') {
      items = [
        NavBarItem(icon: Icons.home, label: 'Home'),
        NavBarItem(icon: Icons.group, label: 'My Network'),
        NavBarItem(icon: Icons.add_box_rounded, label: 'Post'),
        NavBarItem(icon: Icons.play_circle, label: 'Shorts'),
        NavBarItem(icon: Icons.work, label: 'Sponsorships'),
      ];
    } else {
      items = [
        NavBarItem(icon: Icons.home, label: 'Home'),
        NavBarItem(icon: Icons.group, label: 'My Network'),
        NavBarItem(icon: Icons.add_box_rounded, label: 'Post'),
        NavBarItem(icon: Icons.play_circle, label: 'Shorts'),
        NavBarItem(icon: Icons.work, label: 'Athlete'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items.map((item) {
        return SalomonBottomBarItem(
          icon: Icon(item.icon),
          title: Text(item.label),
          selectedColor: Colors.lightBlue,
        );
      }).toList(),
    );
  }
}

class NavBarItem {
  final IconData icon;
  final String label;
  


  const NavBarItem({required this.icon, required this.label});
}