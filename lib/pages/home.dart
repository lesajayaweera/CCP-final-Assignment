import 'package:flutter/material.dart';
import 'package:sport_ignite/widget/common/post.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('asset/image/profile.jpg'),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () => {}, icon: Icon(Icons.message)),
            ],
          ),
          SliverToBoxAdapter(child: LinkedInPostCard(),)
        ],
      ),
    );
  }
}
