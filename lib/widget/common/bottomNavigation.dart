import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final  Function(int) onTap;
  final List<NavBarItem> items;

  const CustomBottomNavigation({super.key,required this.currentIndex, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
       currentIndex: currentIndex,
       onTap: onTap,
      items: items.map((item){
      return SalomonBottomBarItem(icon: Icon(item.icon), title: Text(item.label),selectedColor:Colors.lightBlue );
    }).toList(),
   
    );
  }
}

class NavBarItem {
  final IconData icon;
  final String label;
  


  const NavBarItem({required this.icon, required this.label});
}