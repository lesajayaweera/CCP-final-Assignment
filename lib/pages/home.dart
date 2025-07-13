import 'package:flutter/material.dart';
import 'package:sport_ignite/widget/common/post.dart';
import 'package:sport_ignite/widget/common/profile_with_search_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar
      appBar: CustomAppBar(),

      // Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            Post()


            
            
            
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar:BottomNavigationBar(type: BottomNavigationBarType.fixed,items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group),label: 'My Network'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded),label:'Post'),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill_outlined),label: 'Shorts'),
        BottomNavigationBarItem(icon: Icon(Icons.work),label: 'Sponsorships')
      ]),
    );
  }
}
