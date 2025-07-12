import 'package:flutter/material.dart';

class LinkedInPostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Likes
            Text(
              "Kateryna Luibinskaya and Tatyana Romanova like this",
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),

            /// User Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage("assets/swimmer.jpg"), // Replace with NetworkImage if online
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stanislav Naida • 1st",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Swimmer",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Row(
                        children: [
                          Text("16h", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                          SizedBox(width: 4),
                          Icon(Icons.public, size: 12, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: 12),

            /// Post Content
            Text(
              "Hello, I am looking for a Sponsorship opportunity and would appreciate your support. "
              "Thanks in advance for any contact recommendation, advice, or ...",
              style: TextStyle(fontSize: 14),
            ),

            SizedBox(height: 12),

            /// Reactions and comments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.thumb_up, size: 16, color: Colors.blue),
                  Icon(Icons.favorite, size: 16, color: Colors.red),
                  Icon(Icons.emoji_emotions, size: 16, color: Colors.yellow[700]),
                  SizedBox(width: 4),
                  Text("77"),
                ]),
                Text("11 comments", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),

            Divider(),

            /// Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                postAction(Icons.thumb_up_off_alt, "Like"),
                postAction(Icons.comment_outlined, "Comment"),
                postAction(Icons.share_outlined, "Share"),
                postAction(Icons.send_outlined, "Send"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget postAction(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: Colors.grey[700]),
      label: Text(label, style: TextStyle(color: Colors.grey[700])),
    );
  }
}
