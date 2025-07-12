import 'package:flutter/material.dart';

class Home extends StatelessWidget {
const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Home Page'),
            floating: true,   
            snap: true,
          ),
          
        ],
      ),
      
    );  
  }
}