import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/postService.dart';
import 'package:sport_ignite/widget/post/comments.dart';
import 'package:sport_ignite/widget/post/postAction.dart';
import 'package:sport_ignite/widget/post/postContainer.dart';
import 'package:sport_ignite/widget/post/postHeader.dart';
import 'package:sport_ignite/widget/post/postStats.dart';
import 'package:sport_ignite/widget/post/videoplayer.dart';

// Add this import at the top of your file


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
      final doc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(uid)
          .get();
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
          'rotation': '180', // Add this for inverted images
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
          colors: [Color(0xFFF8FAFC), Color(0xFFE7F3FF)],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadPosts,
        color: const Color(0xFF667eea),
        backgroundColor: Colors.white,
        strokeWidth: 3,
        child: FadeTransition(opacity: _fadeAnimation, child: _buildBody()),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= posts.length) {
              return const SizedBox(height: 100);
            }

            final post = posts[index];
            final postId = post['uid'] + '_' + post['timestamp'].toString();
            final userProfile = userProfiles[post['uid']];

            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final slideAnimation =
                    Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (index * 0.1).clamp(0.0, 0.7),
                          ((index * 0.1) + 0.8).clamp(0.3, 1.0),
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    );

                final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (index * 0.1).clamp(0.0, 0.7),
                          ((index * 0.1) + 0.6).clamp(0.3, 1.0),
                        ),
                      ),
                    );

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
                      onComment: () {
                        showCommentBottomSheet(context, postId: postId); 
                      },
                      onShare: () =>
                          showSnackBar(context, 'Post shared', Colors.green),
                      onSend: () =>
                          showSnackBar(context, 'Message sent', Colors.purple),
                      uid: post['uid'] ?? '',
                      role: post['role'] ?? '',
                    ),
                  ),
                );
              },
            );
          }, childCount: posts.length + 1),
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

// Enhanced MediaGrid Widget with orientation fix
class MediaGrid extends StatefulWidget {
  final List<Map<String, String>> mediaItems;

  const MediaGrid({super.key, required this.mediaItems});

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
          child: GestureDetector(
            onTap: () => _handleMediaTap(widget.mediaItems[0], 0),
            child: _buildMediaItem(
              widget.mediaItems[0],
              aspectRatio: 1 / 1,
              showPlayButton: true,
            ),
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
            child: GestureDetector(
              onTap: () => _handleMediaTap(
                widget.mediaItems[selectedIndex],
                selectedIndex,
              ),
              child: _buildMediaItem(
                widget.mediaItems[selectedIndex],
                aspectRatio: 1 / 1,
                showPlayButton: true,
              ),
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
                              color: const Color(0xFF667eea).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () =>
                          _handleMediaTap(widget.mediaItems[index], index),
                      child: _buildMediaItem(
                        widget.mediaItems[index],
                        aspectRatio: 1,
                        showPlayButton: false,
                        isGrayedOut: !isSelected,
                      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

  void _handleMediaTap(Map<String, String> mediaItem, int index) {
    if (mediaItem['type'] == 'image') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImageViewer(
            mediaItems: widget.mediaItems
                .where((item) => item['type'] == 'image')
                .toList(),
            initialIndex: widget.mediaItems
                .where((item) => item['type'] == 'image')
                .toList()
                .indexWhere((item) => item['url'] == mediaItem['url']),
          ),
        ),
      );
    }
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
      // Enhanced image handling with orientation fix
      mediaWidget = AspectRatio(
        aspectRatio: aspectRatio,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          // Add these properties to handle orientation issues
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  // This can help with some orientation issues
                  alignment: Alignment.center,
                ),
              ),
            );
          },
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
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
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

// Alternative solution: Custom Image Widget with manual rotation
class OrientationFixedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int rotationDegrees; // Add rotation parameter

  const OrientationFixedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.rotationDegrees = 0, // Default no rotation
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationDegrees * (3.14159 / 180), // Convert degrees to radians
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
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
          child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
        ),
      ),
    );
  }
}

// If you want to fix specific images, you can use this approach:
Widget _buildMediaItemWithRotationFix(
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
    // Check if this specific URL needs rotation
    int rotationDegrees = 0;
    if (url.contains('specific-image-identifier') ||
        mediaItem.containsKey('rotation')) {
      rotationDegrees = int.tryParse(mediaItem['rotation'] ?? '0') ?? 0;
    }

    mediaWidget = AspectRatio(
      aspectRatio: aspectRatio,
      child: OrientationFixedImage(
        imageUrl: url,
        fit: BoxFit.cover,
        rotationDegrees: rotationDegrees,
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

// Full-Screen Image Viewer
class FullScreenImageViewer extends StatefulWidget {
  final List<Map<String, String>> mediaItems;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.mediaItems,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int currentIndex;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex.clamp(0, widget.mediaItems.length - 1);
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleUI() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.mediaItems.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _toggleUI,
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.mediaItems[index]['url']!,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.white54,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Failed to load image',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Top UI (Close button and counter)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _isVisible ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Image counter
                  if (widget.mediaItems.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${currentIndex + 1} / ${widget.mediaItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom UI (Thumbnails - optional)
          if (widget.mediaItems.length > 1)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: _isVisible ? 0 : -120,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.mediaItems.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == currentIndex;
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.only(
                          right: index == widget.mediaItems.length - 1 ? 0 : 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: widget.mediaItems[index]['url']!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
