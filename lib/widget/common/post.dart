import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({Key? key}) : super(key: key);

  // final String profileImage ;
  // final String username;
  // final String caption;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // part which the profile details of the posted person
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('asset/image/profile.jpg'),
                    radius: 30,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text('Lesandu Jayaweera'),
                      Text('Swimmer'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('16h'),
                          const SizedBox(width: 5),
                          Icon(Icons.language),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //  COntent
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  'Hello, I am looking for a Sponsorship opportunity and would appreciate your support. Thanks in advance for any contact recommendation, advice, or ... see more',
                ),
                const SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side: Reactions and count
                      Row(
                        children: [
                          // Reaction icons
                          Icon(Icons.thumb_up_alt, color: Colors.blue),
                          Icon(Icons.thumb_up_alt, color: Colors.blue),
                          Icon(Icons.thumb_up_alt, color: Colors.blue),
                          const SizedBox(width: 10),
                          const Text("77", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      // Right side: Comments
                      const Text("11 comments", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          ),

          // Reactions and comments
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                PostAction(icon: Icons.thumb_up_alt_outlined, label: "Like"),
                PostAction(icon: Icons.mode_comment_outlined, label: "Comment"),
                PostAction(icon: Icons.share_outlined, label: "Share"),
                PostAction(icon: Icons.send_outlined, label: "Send"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class TextPost extends StatelessWidget {
  const TextPost({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PostAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const PostAction({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(onPressed: (){},icon: Icon(icon, color: Colors.grey[700], size: 22),),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
      ],
    );
  }
}
