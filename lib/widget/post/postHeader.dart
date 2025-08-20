import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sport_ignite/pages/profile.dart';
import 'package:sport_ignite/pages/profileView.dart';

// Post Header Component
class PostHeader extends StatelessWidget {
  final String userName;
  final String userRole;
  final String timeAgo;
  final String? userAvatar;
  final bool isVerified;
  final String? uid;
  final String role;

  const PostHeader({
    super.key,
    required this.userName,
    required this.userRole,
    required this.timeAgo,
    this.userAvatar,
    this.isVerified = false,
    required this.uid,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // User Avatar with gradient border
        GestureDetector(
          onTap: () {
            if(uid != null && uid!.isNotEmpty) {
              if(uid == FirebaseAuth.instance.currentUser?.uid) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(uid: uid!,role: role,),
                  ),
                );
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileView(uid: uid!, role: role,)));
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667eea).withOpacity(0.8),
                  const Color(0xFF764ba2).withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: null,
                  child: ClipOval(
                    child: userAvatar != null
                        ? CachedNetworkImage(
                            imageUrl: userAvatar!,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            placeholder: (context, url) => 
                                CircularProgressIndicator(strokeWidth: 2),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.person, color: Colors.grey[600], size: 20),
                          )
                        : Icon(Icons.person, color: Colors.grey[600], size: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // User info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  if (isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      color: Color(0xFF3B82F6),
                      size: 16,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  userRole,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667eea),
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.more_horiz,
                color: Colors.grey[600],
                size: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
