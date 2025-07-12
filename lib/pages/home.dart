import 'package:flutter/material.dart';
import 'package:sport_ignite/widget/common/profile_with_search_bar.dart';

class Home extends StatelessWidget {
const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
    
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: CustomSearchBar(image: 'asset/image/profile.jpg'),
            floating: true,
            snap: true,
          ),
          
        ],
      ),
      
    );  
  }
}