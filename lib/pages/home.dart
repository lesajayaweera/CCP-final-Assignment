// import 'package:flutter/material.dart';
// import 'package:sport_ignite/config/essentials.dart';

// // Main Screen
// class SocialFeedScreen extends StatefulWidget {
//   final String role;
//   const SocialFeedScreen({Key? key, required this.role}) : super(key: key);

//   @override
//   State<SocialFeedScreen> createState() => _SocialFeedScreenState();
// }

// class _SocialFeedScreenState extends State<SocialFeedScreen> {
//   List<bool> likedPosts = [false, false];

//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       physics: BouncingScrollPhysics(),
//       children: [
//         // First Post - Swimmer
//         SocialPost(
//           userName: 'Stanislav Naida',
//           userAvatar:
//               'https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//           userRole: 'Swimmer',
//           timeAgo: '1st',
//           postText:
//               'Hello, I am looking for a Sponsorship opportunity and would appreciate your support. Thanks in advance for any contact recommendation, advice or... see more',
//           likes: 77,
//           comments: 11,
//           isLiked: likedPosts[0],
//           onLike: () {
//             setState(() {
//               likedPosts[0] = !likedPosts[0];
//             });
//           },
//           onComment: () => showSnackBar(
//             context,
//             'User has clicked the comments',
//             Colors.black,
//           ),
//           onShare: () =>
//               showSnackBar(context, 'User has clicked the share', Colors.black),
//           onSend: () =>
//               showSnackBar(context, 'User has clicked the send', Colors.black),
//         ),

//         // Second Post - Athlete with Medal
//         SocialPost(
//           userName: 'Vera Drozdova',
//           userRole: 'Athlete',
//           timeAgo: '2 st',
//           userAvatar:
//               'https://images.unsplash.com/photo-1640960543409-dbe56ccc30e2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHVzZXJ8ZW58MHx8MHx8fDA%3D',
//           postText: '',
//           imageUrl: 'asset/image/background.png',
//           likes: 45,
//           comments: 8,
//           isLiked: likedPosts[1],
//           onLike: () {
//             setState(() {
//               likedPosts[1] = !likedPosts[1];
//             });
//           },
//           onComment: () => showSnackBar(
//             context,
//             'User has clicked the comments',
//             Colors.black,
//           ),
//           onShare: () =>
//               showSnackBar(context, 'User has clicked the share', Colors.black),
//           onSend: () =>
//               showSnackBar(context, 'User has clicked the send', Colors.black),
//         ),
//         SocialPost(
//           userName: 'Vera Drozdova',
//           userRole: 'Athlete',
//           timeAgo: '2 st',
//           postText: '',
//           imageUrl: 'asset/image/background.png',
//           likes: 45,
//           comments: 8,
//           isLiked: likedPosts[0],
//           onLike: () {
//             setState(() {
//               likedPosts[0] = !likedPosts[0];
//             });
//           },
//           onComment: () => showSnackBar(
//             context,
//             'User has clicked the comments',
//             Colors.black,
//           ),
//           onShare: () =>
//               showSnackBar(context, 'User has clicked the share', Colors.black),
//           onSend: () =>
//               showSnackBar(context, 'User has clicked the send', Colors.black),
//         ),
//       ],
//     );
//   }
// }

// // Main Post Widget - Reusable
// // ignore: must_be_immutable
// class SocialPost extends StatelessWidget {
//   final String userName;
//   final String userRole;
//   final String timeAgo;
//   final String postText;
//   final String? userAvatar;
//   String? imageUrl;
//   final int likes;
//   final int comments;
//   final VoidCallback? onLike;
//   final VoidCallback? onComment;
//   final VoidCallback? onShare;
//   final VoidCallback? onSend;
//   final bool isLiked;

//   SocialPost({
//     Key? key,
//     required this.userName,
//     required this.userRole,
//     required this.timeAgo,
//     required this.postText,
//     this.userAvatar,
//     this.imageUrl,
//     this.likes = 0,
//     this.comments = 0,
//     this.onLike,
//     this.onComment,
//     this.onShare,
//     this.onSend,
//     this.isLiked = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 0,
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with user info
//             PostHeader(
//               userName: userName,
//               userRole: userRole,
//               timeAgo: timeAgo,
//               userAvatar: userAvatar,
//             ),
//             const SizedBox(height: 12),

//             // Post content
//             Text(
//               postText,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.black87,
//                 height: 1.4,
//               ),
//             ),

//             if (imageUrl != null) Image.asset(imageUrl!, fit: BoxFit.cover),

//             const SizedBox(height: 12),

//             // Engagement stats
//             PostStats(likes: likes, comments: comments),

//             const SizedBox(height: 12),

//             // Action buttons
//             PostActions(
//               onLike: onLike,
//               onComment: onComment,
//               onShare: onShare,
//               onSend: onSend,
//               isLiked: isLiked,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Post Header Component
// class PostHeader extends StatelessWidget {
//   final String userName;
//   final String userRole;
//   final String timeAgo;
//   final String? userAvatar;

//   const PostHeader({
//     Key? key,
//     required this.userName,
//     required this.userRole,
//     required this.timeAgo,
//     this.userAvatar,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // User Avatar
//         CircleAvatar(
//           radius: 20,
//           backgroundColor: Colors.grey[300],
//           backgroundImage: userAvatar != null
//               ? NetworkImage(userAvatar!)
//               : null,
//           child: userAvatar == null
//               ? Icon(Icons.person, color: Colors.grey[600], size: 20)
//               : null,
//         ),
//         const SizedBox(width: 12),

//         // User info
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 userName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 userRole,
//                 style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),

//         // Time and more options
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               timeAgo,
//               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 4),
//             Icon(Icons.more_horiz, color: Colors.grey[600], size: 20),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // Post Stats Component
// class PostStats extends StatelessWidget {
//   final int likes;
//   final int comments;

//   const PostStats({Key? key, required this.likes, required this.comments})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Likes
//         Row(
//           children: [
//             Icon(Icons.favorite, size: 16, color: Colors.grey[600]),
//             const SizedBox(width: 4),
//             Text(
//               likes.toString(),
//               style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//         const SizedBox(width: 16),

//         // Comments
//         Text(
//           '$comments comments',
//           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//         ),
//       ],
//     );
//   }
// }

// // Post Actions Component
// class PostActions extends StatelessWidget {
//   final VoidCallback? onLike;
//   final VoidCallback? onComment;
//   final VoidCallback? onShare;
//   final VoidCallback? onSend;
//   final bool isLiked;

//   const PostActions({
//     Key? key,
//     this.onLike,
//     this.onComment,
//     this.onShare,
//     this.onSend,
//     this.isLiked = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _ActionButton(
//           icon: isLiked ? Icons.favorite : Icons.favorite_border,
//           label: 'Like',
//           onTap: onLike,
//           color: isLiked ? Colors.red : null,
//         ),
//         _ActionButton(
//           icon: Icons.chat_bubble_outline,
//           label: 'Comment',
//           onTap: onComment,
//         ),
//         _ActionButton(
//           icon: Icons.share_outlined,
//           label: 'Share',
//           onTap: onShare,
//         ),
//         _ActionButton(icon: Icons.send_outlined, label: 'Send', onTap: onSend),
//       ],
//     );
//   }
// }

// // Action Button Helper Widget
// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
//   final Color? color;

//   const _ActionButton({
//     Key? key,
//     required this.icon,
//     required this.label,
//     this.onTap,
//     this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Column(
//           children: [
//             Icon(icon, size: 20, color: color ?? Colors.grey[700]),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(fontSize: 12, color: color ?? Colors.grey[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // 

import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';

// Main Screen
class SocialFeedScreen extends StatefulWidget {
  final String role;
  const SocialFeedScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen>
    with TickerProviderStateMixin {
  List<bool> likedPosts = [false, false, false];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8FAFC),
            Color(0xFFEFF6FF),
          ],
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            

            // Posts List
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                
                // First Post - Swimmer
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final slideAnimation = Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
                    ));

                    return SlideTransition(
                      position: slideAnimation,
                      child: SocialPost(
                        userName: 'Stanislav Naida',
                        userAvatar:
                            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        userRole: 'Professional Swimmer',
                        timeAgo: '1h',
                        postText:
                            'Hello, I am looking for a Sponsorship opportunity and would appreciate your support. Thanks in advance for any contact recommendation, advice or guidance! 🏊‍♂️✨',
                        likes: 77,
                        comments: 11,
                        isLiked: likedPosts[0],
                        isVerified: true,
                        onLike: () {
                          setState(() {
                            likedPosts[0] = !likedPosts[0];
                          });
                        },
                        onComment: () => showSnackBar(
                          context,
                          'Comments opened',
                          Colors.blue,
                        ),
                        onShare: () => showSnackBar(
                          context,
                          'Post shared',
                          Colors.green,
                        ),
                        onSend: () => showSnackBar(
                          context,
                          'Message sent',
                          Colors.purple,
                        ),
                      ),
                    );
                  },
                ),

                // Second Post - Athlete with Medal
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final slideAnimation = Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
                    ));

                    return SlideTransition(
                      position: slideAnimation,
                      child: SocialPost(
                        userName: 'Vera Drozdova',
                        userRole: 'Olympic Athlete',
                        timeAgo: '2h',
                        userAvatar:
                            'https://images.unsplash.com/photo-1640960543409-dbe56ccc30e2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHVzZXJ8ZW58MHx8MHx8fDA%3D',
                        postText: 'Another gold medal in the books! 🏅 Thank you to everyone who believed in this journey. The hard work pays off! #NeverGiveUp #GoldMedal',
                        imageUrl: 'asset/image/background.png',
                        likes: 245,
                        comments: 28,
                        isLiked: likedPosts[1],
                        isVerified: true,
                        onLike: () {
                          setState(() {
                            likedPosts[1] = !likedPosts[1];
                          });
                        },
                        onComment: () => showSnackBar(
                          context,
                          'Comments opened',
                          Colors.blue,
                        ),
                        onShare: () => showSnackBar(
                          context,
                          'Post shared',
                          Colors.green,
                        ),
                        onSend: () => showSnackBar(
                          context,
                          'Message sent',
                          Colors.purple,
                        ),
                      ),
                    );
                  },
                ),

                // Third Post
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final slideAnimation = Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
                    ));

                    return SlideTransition(
                      position: slideAnimation,
                      child: SocialPost(
                        userName: 'Alex Johnson',
                        userRole: 'Track & Field',
                        timeAgo: '4h',
                        userAvatar: null,
                        postText: 'Training never stops! Early morning session completed ✅ Who else is putting in the work today? 💪 #TrainingLife #Dedication',
                        likes: 89,
                        comments: 15,
                        isLiked: likedPosts[2],
                        isVerified: false,
                        onLike: () {
                          setState(() {
                            likedPosts[2] = !likedPosts[2];
                          });
                        },
                        onComment: () => showSnackBar(
                          context,
                          'Comments opened',
                          Colors.blue,
                        ),
                        onShare: () => showSnackBar(
                          context,
                          'Post shared',
                          Colors.green,
                        ),
                        onSend: () => showSnackBar(
                          context,
                          'Message sent',
                          Colors.purple,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 80),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Post Widget - Reusable
class SocialPost extends StatefulWidget {
  final String userName;
  final String userRole;
  final String timeAgo;
  final String postText;
  final String? userAvatar;
  final String? imageUrl;
  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSend;
  final bool isLiked;
  final bool isVerified;

  const SocialPost({
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
    this.isVerified = false,
  }) : super(key: key);

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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _likeScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            PostHeader(
              userName: widget.userName,
              userRole: widget.userRole,
              timeAgo: widget.timeAgo,
              userAvatar: widget.userAvatar,
              isVerified: widget.isVerified,
            ),
            const SizedBox(height: 16),

            // Post content
            if (widget.postText.isNotEmpty)
              Text(
                widget.postText,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1E293B),
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),

            if (widget.postText.isNotEmpty) const SizedBox(height: 16),

            if (widget.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    widget.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

            if (widget.imageUrl != null) const SizedBox(height: 16),

            // Engagement stats
            PostStats(
              likes: widget.likes,
              comments: widget.comments,
            ),

            const SizedBox(height: 16),
            
            // Divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[200]!,
                    Colors.grey[300]!,
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons
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
              onComment: widget.onComment,
              onShare: widget.onShare,
              onSend: widget.onSend,
              isLiked: widget.isLiked,
              likeAnimation: _likeScaleAnimation,
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
  final bool isVerified;

  const PostHeader({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.timeAgo,
    this.userAvatar,
    this.isVerified = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // User Avatar with gradient border
        Container(
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
                backgroundImage: userAvatar != null
                    ? NetworkImage(userAvatar!)
                    : null,
                child: userAvatar == null
                    ? Icon(Icons.person, color: Colors.grey[600], size: 20)
                    : null,
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

// Post Stats Component
class PostStats extends StatelessWidget {
  final int likes;
  final int comments;

  const PostStats({
    Key? key,
    required this.likes,
    required this.comments,
  }) : super(key: key);

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

// Post Actions Component
class PostActions extends StatelessWidget {
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSend;
  final bool isLiked;
  final Animation<double> likeAnimation;

  const PostActions({
    Key? key,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSend,
    this.isLiked = false,
    required this.likeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ScaleTransition(
          scale: likeAnimation,
          child: _ActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            label: 'Like',
            onTap: onLike,
            color: isLiked ? const Color(0xFFFF6B6B) : null,
            isActive: isLiked,
          ),
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
        _ActionButton(
          icon: Icons.send_outlined,
          label: 'Send',
          onTap: onSend,
        ),
      ],
    );
  }
}

// Action Button Helper Widget
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool isActive;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.color?.withOpacity(0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isActive
                  ? widget.color?.withOpacity(0.3) ?? Colors.grey[200]!
                  : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.color ?? const Color(0xFF64748B),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.color ?? const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}