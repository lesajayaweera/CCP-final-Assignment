import 'package:flutter/material.dart';

class Home extends StatelessWidget {
const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
    
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Home Page',style: TextStyle(fontFamily: 'Main',fontWeight: FontWeight.bold),),
            floating: true,   
            snap: true,
          ),
          
        ],
      ),
      
    );  
  }
}