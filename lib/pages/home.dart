import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/postService.dart';
import 'package:sport_ignite/widget/post/postAction.dart';
import 'package:sport_ignite/widget/post/postHeader.dart';
import 'package:sport_ignite/widget/post/postStats.dart';
import 'package:sport_ignite/widget/post/videoplayer.dart';
import 'package:video_player/video_player.dart';

// Main Screen
class SocialFeedScreen extends StatefulWidget {
  final String role;
  const SocialFeedScreen({super.key, required this.role});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> posts = [];
  Map<String, bool> likedPosts = {};
  Map<String, Map<String, dynamic>?> userProfiles = {};
  bool isLoading = true;
  String? error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedPosts = await PostService.getPostsForUserSport(widget.role);

      Map<String, bool> initialLikedStatus = {};
      for (var post in fetchedPosts) {
        final postId = post['uid'] + '_' + post['timestamp'].toString();
        initialLikedStatus[postId] = false;
      }

      Map<String, Map<String, dynamic>?> profiles = {};
      for (var post in fetchedPosts) {
        final uid = post['uid'];
        if (!profiles.containsKey(uid)) {  
          profiles[uid] = await _getUserProfile(uid, post['role']);
        }
      }

      setState(() {
        posts = fetchedPosts;
        likedPosts = initialLikedStatus;
        userProfiles = profiles;
        isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _getUserProfile(String uid, String role) async {
    try {
      String collection = role == 'Athlete' ? 'athlete' : 'sponsor';
      final doc = await FirebaseFirestore.instance.collection(collection).doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  String _getTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    
    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else {
      return 'Unknown';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  List<Map<String, String>> _getPostMedia(dynamic media) {
    List<Map<String, String>> mediaList = [];
    
    if (media == null) return mediaList;
    
    List<dynamic> mediaUrls = [];
    if (media is List) {
      mediaUrls = media;
    } else if (media is String && media.isNotEmpty) {
      mediaUrls = [media];
    }
    
    for (var url in mediaUrls) {
      String urlString = url.toString();
      if (urlString.isNotEmpty) {
        String mediaType = _getMediaType(urlString);
        mediaList.add({
          'url': urlString,
          'type': mediaType,
        });
      }
    }
    
    return mediaList;
  }

  String _getMediaType(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m4v'];
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    
    String lowerUrl = url.toLowerCase();
    
    for (String ext in videoExtensions) {
      if (lowerUrl.contains(ext)) {
        return 'video';
      }
    }
    
    for (String ext in imageExtensions) {
      if (lowerUrl.contains(ext)) {
        return 'image';
      }
    }
    
    return 'image';
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
            Color(0xFFE7F3FF),
          ],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadPosts,
        color: const Color(0xFF667eea),
        backgroundColor: Colors.white,
        strokeWidth: 3,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                color: Color(0xFF667eea),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading amazing content...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loadPosts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (posts.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF667eea).withOpacity(0.1),
                      const Color(0xFF764ba2).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.sports_outlined,
                  size: 64,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No posts yet!',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Be the first to share something amazing\nin your sport community',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= posts.length) {
                return const SizedBox(height: 100);
              }

              final post = posts[index];
              final postId = post['uid'] + '_' + post['timestamp'].toString();
              final userProfile = userProfiles[post['uid']];
              
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      (index * 0.1).clamp(0.0, 0.7),
                      ((index * 0.1) + 0.8).clamp(0.3, 1.0),
                      curve: Curves.easeOutCubic,
                    ),
                  ));

                  final opacityAnimation = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      (index * 0.1).clamp(0.0, 0.7),
                      ((index * 0.1) + 0.6).clamp(0.3, 1.0),
                    ),
                  ));

                  return FadeTransition(
                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: SocialPost(
                        userName: _getUserName(userProfile, post['role']),
                        userAvatar: _getUserAvatar(userProfile),
                        userRole: _getUserRole(userProfile, post['role']),
                        timeAgo: _getTimeAgo(post['timestamp']),
                        postText: post['text'] ?? '',
                        mediaItems: _getPostMedia(post['media']),
                        likes: post['likes'] ?? 0,
                        comments: post['comments'] ?? 0,
                        isLiked: likedPosts[postId] ?? false,
                        isVerified: _isUserVerified(userProfile, post['role']),
                        onLike: () {
                          setState(() {
                            likedPosts[postId] = !(likedPosts[postId] ?? false);
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
                        uid: post['uid'] ?? '',
                      ),
                    ),
                  );
                },
              );
            },
            childCount: posts.length + 1,
          ),
        ),
      ],
    );
  }

  String _getUserName(Map<String, dynamic>? profile, String role) {
    if (profile == null) return 'Unknown User';
    
    if (role == 'Athlete') {
      return profile['name'] ?? 'Unknown Athlete';
    } else {
      return profile['name'] ?? 'Unknown Sponsor';
    }
  }

  String? _getUserAvatar(Map<String, dynamic>? profile) {
    if (profile == null) return null;
    return profile['profile'] ?? profile['profile'];
  }

  String _getUserRole(Map<String, dynamic>? profile, String role) {
    if (profile == null) return role;
    
    if (role == 'Athlete') {
      final sport = profile['sport'] ?? '';
      final category = profile['role'] ?? '';
      if (sport.isNotEmpty && category.isNotEmpty) {
        return '$category $sport';
      } else if (sport.isNotEmpty) {
        return sport;
      }
      return 'Athlete';
    } else {
      return profile['company'] ?? 'Sponsor';
    }
  }

  bool _isUserVerified(Map<String, dynamic>? profile, String role) {
    if (profile == null) return false;
    return profile['isVerified'] ?? false;
  }
}

// Enhanced SocialPost Widget
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
                  PostStats(
                    likes: widget.likes,
                    comments: widget.comments,
                  ),
                  
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
                    onComment: widget.onComment,
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

// New MediaGrid Widget for better media display


// New MediaGrid Widget for better media display
class MediaGrid extends StatefulWidget {
  final List<Map<String, String>> mediaItems;

  const MediaGrid({
    super.key,
    required this.mediaItems,
  });

  @override
  State<MediaGrid> createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItems.isEmpty) return const SizedBox();

    // Single media item
    if (widget.mediaItems.length == 1) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildMediaItem(
            widget.mediaItems[0],
            aspectRatio: 1 / 1,
            showPlayButton: true,
          ),
        ),
      );
    }

    // Multiple media items - Grid layout
    return Column(
      children: [
        // Main selected media
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildMediaItem(
              widget.mediaItems[selectedIndex],
              aspectRatio: 1 / 1,
              showPlayButton: true,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Thumbnail grid
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.mediaItems.length,
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  width: 80,
                  margin: EdgeInsets.only(
                    right: index == widget.mediaItems.length - 1 ? 0 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF667eea)
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  const Color(0xFF667eea).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildMediaItem(
                      widget.mediaItems[index],
                      aspectRatio: 1,
                      showPlayButton: false,
                      isGrayedOut: !isSelected,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Media counter
        if (widget.mediaItems.length > 1)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${selectedIndex + 1} of ${widget.mediaItems.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMediaItem(
    Map<String, String> mediaItem, {
    required double aspectRatio,
    bool showPlayButton = false,
    bool isGrayedOut = false,
  }) {
    String url = mediaItem['url']!;
    String type = mediaItem['type']!;

    Widget mediaWidget;

    if (type == 'video') {
      mediaWidget = VideoPlayerWidget(
        url: url,
        showControls: showPlayButton,
        aspectRatio: aspectRatio,
      );
    } else {
      // ✅ Cached images for better performance
      mediaWidget = AspectRatio(
        aspectRatio: aspectRatio,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF667eea),
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  size: showPlayButton ? 40 : 24,
                  color: Colors.grey[400],
                ),
                if (showPlayButton) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Image failed to load',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    if (isGrayedOut) {
      mediaWidget = ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.3),
          BlendMode.darken,
        ),
        child: mediaWidget,
      );
    }

    return mediaWidget;
  }
}
