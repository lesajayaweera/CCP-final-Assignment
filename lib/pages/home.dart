import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/postService.dart';
import 'package:sport_ignite/widget/post/postAction.dart';
import 'package:sport_ignite/widget/post/postHeader.dart';
import 'package:sport_ignite/widget/post/postStats.dart';
// Add video player dependency
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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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

  // Enhanced method to get all media items with type detection
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

  // Helper method to determine media type based on URL/extension
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
    
    // Default fallback - you might want to improve this logic
    // based on your specific URL patterns or add API calls to check content type
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
            Color(0xFFEFF6FF),
          ],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadPosts,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF667eea),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading posts',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPosts,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No posts available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new posts in your sport',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return const SizedBox(height: 16);
              }
              
              final postIndex = index - 1;
              if (postIndex >= posts.length) {
                return const SizedBox(height: 80);
              }

              final post = posts[postIndex];
              final postId = post['uid'] + '_' + post['timestamp'].toString();
              final userProfile = userProfiles[post['uid']];
              
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      (postIndex * 0.1).clamp(0.0, 0.8),
                      ((postIndex * 0.1) + 0.6).clamp(0.2, 1.0),
                      curve: Curves.easeOutBack,
                    ),
                  ));

                  return SlideTransition(
                    position: slideAnimation,
                    child: SocialPost(
                      userName: _getUserName(userProfile, post['role']),
                      userAvatar: _getUserAvatar(userProfile),
                      userRole: _getUserRole(userProfile, post['role']),
                      timeAgo: _getTimeAgo(post['timestamp']),
                      postText: post['text'] ?? '',
                      mediaItems: _getPostMedia(post['media']), // Changed from imageUrl
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
                  );
                },
              );
            },
            childCount: posts.length + 2,
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

// Updated SocialPost Widget with Media Support
class SocialPost extends StatefulWidget {
  final String userName;
  final String userRole;
  final String timeAgo;
  final String postText;
  final String? userAvatar;
  final List<Map<String, String>> mediaItems; // Changed from imageUrl
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
    this.mediaItems = const [], // Changed default
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
              uid: widget.uid,
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

            // Media content (images and videos)
            if (widget.mediaItems.isNotEmpty)
              MediaCarousel(mediaItems: widget.mediaItems),

            if (widget.mediaItems.isNotEmpty) const SizedBox(height: 16),

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

// New MediaCarousel Widget to handle multiple media items
class MediaCarousel extends StatefulWidget {
  final List<Map<String, String>> mediaItems;

  const MediaCarousel({
    super.key,
    required this.mediaItems,
  });

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItems.isEmpty) return const SizedBox();

    return Column(
      children: [
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
            child: _buildMediaItem(widget.mediaItems[currentIndex]),
          ),
        ),
        if (widget.mediaItems.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: currentIndex > 0 ? () {
                  setState(() {
                    currentIndex--;
                  });
                } : null,
                icon: const Icon(Icons.arrow_back_ios),
                iconSize: 20,
              ),
              ...List.generate(
                widget.mediaItems.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index 
                        ? const Color(0xFF667eea) 
                        : Colors.grey[400],
                  ),
                ),
              ),
              IconButton(
                onPressed: currentIndex < widget.mediaItems.length - 1 ? () {
                  setState(() {
                    currentIndex++;
                  });
                } : null,
                icon: const Icon(Icons.arrow_forward_ios),
                iconSize: 20,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMediaItem(Map<String, String> mediaItem) {
    String url = mediaItem['url']!;
    String type = mediaItem['type']!;

    if (type == 'video') {
      return VideoPlayerWidget(url: url);
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey,
              ),
            ),
          );
        },
      );
    }
  }
}

// Video Player Widget
class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({
    super.key,
    required this.url,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _controller = VideoPlayerController.network(widget.url);
      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                'Failed to load video',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller!),
          IconButton(
            onPressed: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              });
            },
            icon: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 50,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}