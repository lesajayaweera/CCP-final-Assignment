import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String image ;
  const CustomSearchBar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        CircleAvatar(
          backgroundImage: AssetImage(image),
          radius: 20,

        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.message_rounded),
          onPressed: () {
            // Implement search functionality here
          },
        ),
      ],),
      
      
    );
  }
}
