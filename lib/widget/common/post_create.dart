import 'package:flutter/material.dart';
import 'package:sport_ignite/model/User.dart';



void openShareBottomSheet(BuildContext context,String role) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        maxChildSize: 0.95,
        builder: (_, controller) => SharePostSheet(scrollController: controller, role: role),
      ),
    );
  }

class SharePostSheet extends StatelessWidget {
  final ScrollController scrollController;
  final String role;

  const SharePostSheet({required this.scrollController,required this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar mimic
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              Text('Share post', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () {},
                child: Text('Post', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        Divider(),

        // User Info
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              FutureBuilder<String?>(
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
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KUMAR SANGAKKAR', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.public, size: 16),
                      SizedBox(width: 4),
                      Text('Anyone'),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),

        // Input prompt
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('What do you want to talk about?', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ),

        // Drag Handle
        Container(
          height: 4,
          width: 40,
          margin: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // Scrollable options
        Expanded(
          child: ListView(
            controller: scrollController,
            children: [
              _postOption(Icons.photo, "Add a photo"),
              _postOption(Icons.videocam, "Take a video"),
              _postOption(Icons.celebration, "Celebrate an occasion"),
              _postOption(Icons.insert_drive_file, "Add a document"),
              _postOption(Icons.work, "Share that you’re hiring"),
              _postOption(Icons.person_search, "Find an expert"),
              _postOption(Icons.poll, "Create a poll"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _postOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(label),
      onTap: () {},
    );
  }
}
