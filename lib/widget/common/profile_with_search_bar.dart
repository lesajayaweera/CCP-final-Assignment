import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      // decoration: BoxDecoration(color: Colors.lightBlue),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('asset/image/profile.jpg'),
                radius: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(decoration: InputDecoration(hint: Text('Search'))),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.message_rounded)),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
