import 'package:flutter/material.dart';
import 'package:sport_ignite/widget/common/appbar.dart';
import 'package:sport_ignite/widget/common/bottomNavigation.dart';

// Main Post Widget - Reusable
class SocialPost extends StatelessWidget {
  final String userName;
  final String userRole;
  final String timeAgo;
  final String postText;
  final String? userAvatar;
  String? imageUrl;
  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSend;
  final bool isLiked;

  SocialPost({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.timeAgo,
    required this.postText,
    this.userAvatar,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSend,
    this.isLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            PostHeader(
              userName: userName,
              userRole: userRole,
              timeAgo: timeAgo,
              userAvatar: userAvatar,
            ),
            const SizedBox(height: 12),

            // Post content
            Text(
              postText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),

            if (imageUrl != null) Image.asset(imageUrl!, fit: BoxFit.cover),

            const SizedBox(height: 12),

            // Engagement stats
            PostStats(likes: likes, comments: comments),

            const SizedBox(height: 12),

            // Action buttons
            PostActions(
              onLike: onLike,
              onComment: onComment,
              onShare: onShare,
              onSend: onSend,
              isLiked: isLiked,
            ),
          ],
        ),
      ),
    );
  }
}

// Post Header Component
class PostHeader extends StatelessWidget {
  final String userName;
  final String userRole;
  final String timeAgo;
  final String? userAvatar;

  const PostHeader({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.timeAgo,
    this.userAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // User Avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          backgroundImage: userAvatar != null
              ? NetworkImage(userAvatar!)
              : null,
          child: userAvatar == null
              ? Icon(Icons.person, color: Colors.grey[600], size: 20)
              : null,
        ),
        const SizedBox(width: 12),

        // User info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userRole,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Time and more options
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeAgo,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Icon(Icons.more_horiz, color: Colors.grey[600], size: 20),
          ],
        ),
      ],
    );
  }
}

// Post Stats Component
class PostStats extends StatelessWidget {
  final int likes;
  final int comments;

  const PostStats({Key? key, required this.likes, required this.comments})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Likes
        Row(
          children: [
            Icon(Icons.favorite, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              likes.toString(),
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(width: 16),

        // Comments
        Text(
          '$comments comments',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

// Post Actions Component
class PostActions extends StatelessWidget {
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSend;
  final bool isLiked;

  const PostActions({
    Key? key,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSend,
    this.isLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: 'Like',
          onTap: onLike,
          color: isLiked ? Colors.red : null,
        ),
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: 'Comment',
          onTap: onComment,
        ),
        _ActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: onShare,
        ),
        _ActionButton(icon: Icons.send_outlined, label: 'Send', onTap: onSend),
      ],
    );
  }
}

// Action Button Helper Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color ?? Colors.grey[700]),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color ?? Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}



// Main Screen
class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  List<bool> likedPosts = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LinkedInAppBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        children: [
          // First Post - Swimmer
          SocialPost(
            userName: 'Stanislav Naida',
            userAvatar: 'https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            userRole: 'Swimmer',
            timeAgo: '1 st',
            postText:
                'Hello, I am looking for a Sponsorship opportunity and would appreciate your support. Thanks in advance for any contact recommendation, advice or... see more',
            likes: 77,
            comments: 11,
            isLiked: likedPosts[0],
            onLike: () {
              setState(() {
                likedPosts[0] = !likedPosts[0];
              });
            },
            onComment: () => _showSnackBar(context, 'Comment tapped'),
            onShare: () => _showSnackBar(context, 'Share tapped'),
            onSend: () => _showSnackBar(context, 'Send tapped'),
          ),

          // Second Post - Athlete with Medal
          SocialPost(
            userName: 'Vera Drozdova',
            userRole: 'Athlete',
            timeAgo: '2 st',
            userAvatar: 'https://images.unsplash.com/photo-1640960543409-dbe56ccc30e2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHVzZXJ8ZW58MHx8MHx8fDA%3D',
            postText: '',
            imageUrl: 'asset/image/background.png',
            likes: 45,
            comments: 8,
            isLiked: likedPosts[1],
            onLike: () {
              setState(() {
                likedPosts[1] = !likedPosts[1];
              });
            },
            onComment: () => _showSnackBar(context, 'Comment tapped'),
            onShare: () => _showSnackBar(context, 'Share tapped'),
            onSend: () => _showSnackBar(context, 'Send tapped'),
          ),
          SocialPost(
            userName: 'Vera Drozdova',
            userRole: 'Athlete',
            timeAgo: '2 st',
            postText: '',
            imageUrl: 'asset/image/background.png',
            likes: 45,
            comments: 8,
            isLiked: likedPosts[1],
            onLike: () {
              setState(() {
                likedPosts[1] = !likedPosts[1];
              });
            },
            onComment: () => _showSnackBar(context, 'Comment tapped'),
            onShare: () => _showSnackBar(context, 'Share tapped'),
            onSend: () => _showSnackBar(context, 'Send tapped'),
          ),
        ],
      ),
     
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
