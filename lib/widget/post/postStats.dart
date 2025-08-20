import 'package:flutter/material.dart';

// Post Stats Component
class PostStats extends StatelessWidget {
  final int likes;
  final int comments;

  const PostStats({
    super.key,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Likes with heart icons
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                size: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${likes.toString()} likes',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),

        // Comments
        Text(
          '$comments comments',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
