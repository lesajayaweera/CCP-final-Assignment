import 'package:flutter/material.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/pages/profile.dart';

class LinkedInAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool page;
  final String role;

  const LinkedInAppBar({super.key, required this.page,required this.role});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: page,
      titleSpacing: 10,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!page)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(role: role,)),
                );
              },
              child: FutureBuilder<String?>(
                future: Users().getUserProfileImage(role),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!),
                    );
                  } else {
                    return const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person),
                    );
                  }
                },
              ),
            ),
          if (!page)
            const SizedBox(width: 10), // Add spacing only if avatar shown
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.message_rounded, color: Colors.black),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

//   backgroundColor: Colors.white,
      //   elevation: 1,
      //   automaticallyImplyLeading: false,
      //   titleSpacing: 10,
      //   title: Row(
      //     children: [
      //       // LinkedIn logo
      //       const SizedBox(width: 10),

      //       // Search bar
      //       Expanded(
      //         child: Container(
      //           height: 36,
      //           padding: const EdgeInsets.symmetric(horizontal: 12),
      //           decoration: BoxDecoration(
      //             color: Colors.grey[200],
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           child: TextField(
      //             decoration: InputDecoration(
      //               icon: Icon(Icons.search),
      //               border: InputBorder.none,
      //               hint: Text('Search here'),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.message, color: Colors.grey),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.notifications_none, color: Colors.grey),
      //       onPressed: () {},
      //     ),
      //   ],