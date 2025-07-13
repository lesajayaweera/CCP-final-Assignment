import 'package:flutter/material.dart';

// class CustomAppBar extends StatelessWidget {
//   const CustomAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(5),
//       // decoration: BoxDecoration(color: Colors.lightBlue),
//       child: Column(
        // children: [
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       CircleAvatar(
        //         backgroundImage: AssetImage('asset/image/profile.jpg'),
        //         radius: 24,
        //       ),
        //       const SizedBox(width: 10),
        //       Expanded(
        //         child: TextField(decoration: InputDecoration(hint: Text('Search'))),
        //       ),
        //       IconButton(onPressed: () {}, icon: Icon(Icons.message_rounded)),
        //     ],
        //   ),
        //   Divider()
        // ],
//       ),
//     );
//   }
// }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Optional: hides default back button
      elevation: 1,
      backgroundColor: Colors.white,     // Optional: set background color
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('asset/image/profile.jpg'),
                      radius: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.message_rounded, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const Divider(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
