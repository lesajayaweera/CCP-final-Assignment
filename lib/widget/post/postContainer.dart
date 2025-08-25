import 'package:flutter/material.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/widget/post/comments.dart';
import 'package:sport_ignite/widget/post/postAction.dart';
import 'package:sport_ignite/widget/post/postHeader.dart';
import 'package:sport_ignite/widget/post/postStats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_ignite/widget/post/widget/homeScreenHelper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class SocialPost extends StatefulWidget {
  final String userName;
  final String userRole;
  final String timeAgo;
  final String postText;
  final String? userAvatar;
  final List<Map<String, String>> mediaItems;
  final int likes;
  final int comments;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSend;
  final bool isLiked;
  final bool isVerified;
  final String uid;
  final String role;
  final String postId;

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
    this.onComment,
    this.onShare,
    this.onSend,
    this.isLiked = false,
    this.isVerified = false,
    required this.uid,
    required this.role,
    required this.postId,
  });

  @override
  State<SocialPost> createState() => _SocialPostState();
}

class _SocialPostState extends State<SocialPost>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;
  final GlobalKey shareableContentKey = GlobalKey();

  // Local state for like status and count
  late bool _isLiked;
  late int _likeCount;
  bool _isLiking = false; // Prevent multiple simultaneous requests

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.likes;

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

  // Add like method implementation
  Future<void> _addLike() async {
    if (_isLiking) return; // Prevent multiple requests

    setState(() {
      _isLiking = true;
    });

    try {
      final String currentUid = FirebaseAuth.instance.currentUser!.uid;

      // Get user data (you'll need to import your Users class)
      final Map<String, dynamic>? userdata = await Users.getUserDetailsByUid(
        context,
        currentUid,
      );

      final likeRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('likes')
          .doc(currentUid);

      final docSnapshot = await likeRef.get();

      if (docSnapshot.exists) {
        // Remove like
        await likeRef.delete();
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .update({'likes': FieldValue.increment(-1)});

        // Update local state
        setState(() {
          _isLiked = false;
          _likeCount = _likeCount - 1;
        });
      } else {
        // Add like
        await likeRef.set({
          'uid': currentUid,
          'username': userdata?['name'],
          'userRole': userdata?['role'],
          'userAvatar': userdata?['profile'],
          'timestamp': FieldValue.serverTimestamp(),
        });

        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .update({'likes': FieldValue.increment(1)});

        // Update local state
        setState(() {
          _isLiked = true;
          _likeCount = _likeCount + 1;
        });
      }
    } catch (e) {
      // Handle error - you might want to show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating like: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLiking = false;
      });
    }
  }

  void _handleLike() async {
    // Optimistic UI update
    if (_isLiked) {
      _likeAnimationController.reverse();
    } else {
      _likeAnimationController.forward().then((_) {
        _likeAnimationController.reverse();
      });
    }

    // Call the actual like method
    await _addLike();
  }

  void _sharePost() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Share Post',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.text_fields, color: Colors.blue),
                title: const Text('Share as Text'),
                onTap: () async {
                  Navigator.pop(context);
                  String shareText =
                      "Check out this post by ${widget.userName}:\n\n${widget.postText}";
                  await Share.share(shareText);
                },
              ),

              ListTile(
                leading: const Icon(Icons.link, color: Colors.orange),
                title: const Text('Copy Link'),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(
                    ClipboardData(
                      text: "https://sportignite.app/post/${widget.postId}",
                    ),
                  );
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Link copied!')));
                },
              ),

              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.grey),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _openComments() {
    showCommentBottomSheet(context, postId: widget.postId);
    print(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: shareableContentKey,
      child: Container(
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
                    // Stats - Use local state values
                    PostStats(likes: _likeCount, comments: widget.comments),
      
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
                      onLike: _handleLike,
                      onComment: _openComments,
                      onShare: _sharePost,
                      onSend: widget.onSend,
                      isLiked: _isLiked, // Use local state
                      likeAnimation: _likeScaleAnimation,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
