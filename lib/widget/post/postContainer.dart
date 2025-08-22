import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/home.dart';
import 'package:sport_ignite/widget/post/comments.dart';
import 'package:sport_ignite/widget/post/postAction.dart';
import 'package:sport_ignite/widget/post/postHeader.dart';
import 'package:sport_ignite/widget/post/postStats.dart';


class SocialPost extends StatefulWidget {
  final String userName;
  final String userRole;
  final String timeAgo;
  final String postText;
  final String? userAvatar;
  final List<Map<String, String>> mediaItems;
  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSend;
  final bool isLiked;
  final bool isVerified;
  final String uid;
  final String role;
  final String? postId;

  const SocialPost({
    super.key,
    required this.userName,
    required this.userRole,
    required this.timeAgo,
    required this.postText,
    this.userAvatar,
    this.mediaItems = const [],
    this.likes = 0,
    this.comments = 0,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSend,
    this.isLiked = false,
    this.isVerified = false,
    required this.uid,
    required this.role,
    this.postId,
  });

  @override
  State<SocialPost> createState() => _SocialPostState();
}

class _SocialPostState extends State<SocialPost>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _likeScaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _openComments() {
    showCommentBottomSheet(
      context,
      postId: widget.postId ?? widget.uid,
      comments: widget.comments,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: PostHeader(
                userName: widget.userName,
                userRole: widget.userRole,
                timeAgo: widget.timeAgo,
                userAvatar: widget.userAvatar,
                isVerified: widget.isVerified,
                uid: widget.uid,
                role: widget.role,
              ),
            ),

            // Post content
            if (widget.postText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.postText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

            if (widget.postText.isNotEmpty) const SizedBox(height: 16),

            // Media content
            if (widget.mediaItems.isNotEmpty)
              MediaGrid(mediaItems: widget.mediaItems),

            // Stats and actions
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Stats
                  PostStats(likes: widget.likes, comments: widget.comments),

                  const SizedBox(height: 16),

                  // Elegant divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey[300]!,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Actions
                  PostActions(
                    onLike: () {
                      if (widget.isLiked) {
                        _likeAnimationController.reverse();
                      } else {
                        _likeAnimationController.forward().then((_) {
                          _likeAnimationController.reverse();
                        });
                      }
                      widget.onLike?.call();
                    },
                    onComment: () {
                      _openComments();
                      widget.onComment?.call();
                    },
                    onShare: widget.onShare,
                    onSend: widget.onSend,
                    isLiked: widget.isLiked,
                    likeAnimation: _likeScaleAnimation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}