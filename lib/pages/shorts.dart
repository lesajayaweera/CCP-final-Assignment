import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_ignite/model/postService.dart';
import 'package:sport_ignite/pages/profile.dart';
import 'package:sport_ignite/pages/profileView.dart';
import 'package:sport_ignite/widget/post/comments.dart';
import 'package:sport_ignite/widget/post/shorts/sideActions.dart';
import 'package:video_player/video_player.dart';

class ShortsPage extends StatefulWidget {
  final String role;
  const ShortsPage({super.key, required this.role});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> with TickerProviderStateMixin {
  PageController _pageController = PageController();
  List<Map<String, dynamic>> _videoPosts = [];
  List<VideoPlayerController?> _controllers = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  late AnimationController _loadingController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _loadVideos();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    for (var controller in _controllers) {
      controller?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    try {
      final videos = await PostService.getVideoPosts(context,widget.role);
      setState(() {
        _videoPosts = videos;
        _controllers = List.generate(videos.length, (_) => null);
        _isLoading = false;
      });

      if (videos.isNotEmpty) {
        _initializeController(0);
      }
    } catch (e) {
      print('Error loading videos: $e');
      setState(() => _isLoading = false);
    }
  }

  void _initializeController(int index) {
    if (index >= _videoPosts.length || _controllers[index] != null) return;

    final videoUrl = _getVideoUrl(_videoPosts[index]);
    if (videoUrl != null && videoUrl.isNotEmpty) {
      final uri = Uri.tryParse(videoUrl);

      if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
        print('Skipping invalid video URL at index $index: $videoUrl');
        return;
      }

      _controllers[index] = VideoPlayerController.networkUrl(uri)
        ..setLooping(true)
        ..initialize()
            .then((_) {
              if (mounted && index == _currentIndex) {
                setState(() {});
                _controllers[index]?.play();
              }
            })
            .catchError((error) {
              print('Error initializing video $index: $error');
              _controllers[index]?.dispose();
              _controllers[index] = null;
            });
    } else {
      print('No valid video URL found at index $index');
    }
  }

  String? _getVideoUrl(Map<String, dynamic> post) {
    final media = post['media'] as List?;
    if (media == null || media.isEmpty) return null;

    for (var url in media) {
      if (url == null) continue;

      final urlString = url.toString().trim();
      if (urlString.isEmpty) continue;

      if ((urlString.startsWith('http://') ||
              urlString.startsWith('https://')) &&
          (urlString.toLowerCase().contains('.mp4') ||
              urlString.toLowerCase().contains('.mov') ||
              urlString.toLowerCase().contains('.avi') ||
              urlString.toLowerCase().contains('.mkv'))) {
        return urlString;
      }
    }
    return null;
  }

  void _onPageChanged(int index) {
    _controllers[_currentIndex]?.pause();

    setState(() {
      _currentIndex = index;
    });

    if (_controllers[index] == null) {
      _initializeController(index);
    } else {
      _controllers[index]?.play();
    }

    if (index + 1 < _videoPosts.length && _controllers[index + 1] == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _initializeController(index + 1);
      });
    }

    for (int i = 0; i < _controllers.length; i++) {
      if (i < index - 1 || i > index + 2) {
        if (_controllers[i] != null) {
          _controllers[i]?.dispose();
          _controllers[i] = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? _buildLoadingScreen()
          : _videoPosts.isEmpty
          ? _buildEmptyState()
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: _videoPosts.length,
              itemBuilder: (context, index) {
                return ShortsPlayerWidget(
                  post: _videoPosts[index],
                  controller: _controllers[index],
                  isActive: index == _currentIndex,
                );
              },
            ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _loadingController,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue, Colors.pink],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Loading awesome content...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.video_library_outlined,
              color: Colors.white70,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No videos available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new content',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ShortsPlayerWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  final VideoPlayerController? controller;
  final bool isActive;

  const ShortsPlayerWidget({
    super.key,
    required this.post,
    required this.controller,
    required this.isActive,
  });

  @override
  State<ShortsPlayerWidget> createState() => _ShortsPlayerWidgetState();
}

// class _ShortsPlayerWidgetState extends State<ShortsPlayerWidget>
//     with TickerProviderStateMixin {
//   bool isPlaying = false;
//   bool isMuted = false;
//   double currentPosition = 0.0;
//   String currentTime = "0:00";
//   String totalTime = "0:00";
//   bool isLiked = false;
//   bool isBookmarked = false;
//   bool _showControls = true;

//   late AnimationController _playPauseController;
//   late AnimationController _likeController;
//   late AnimationController _pulseController;
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;

//   @override
//   void initState() {
//     super.initState();

//     _playPauseController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _likeController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//       value: 1.0,
//     );

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//     );

//     _setupVideoListener();
//     _startAutoHideControls();
//   }

//   void _startAutoHideControls() {
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _showControls) {
//         _fadeController.reverse();
//         setState(() => _showControls = false);
//       }
//     });
//   }

//   void _showControlsTemporary() {
//     setState(() => _showControls = true);
//     _fadeController.forward();
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _showControls) {
//         _fadeController.reverse();
//         setState(() => _showControls = false);
//       }
//     });
//   }

//   void _setupVideoListener() {
//     widget.controller?.addListener(() {
//       if (widget.controller!.value.isInitialized && mounted) {
//         final pos = widget.controller!.value.position;
//         final dur = widget.controller!.value.duration;
//         setState(() {
//           currentPosition = dur.inMilliseconds > 0
//               ? pos.inMilliseconds / dur.inMilliseconds
//               : 0.0;
//           currentTime = _formatDuration(pos);
//           totalTime = _formatDuration(dur);
//           isPlaying = widget.controller!.value.isPlaying;
//         });
//       }
//     });
//   }

//   @override
//   void didUpdateWidget(ShortsPlayerWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.controller != oldWidget.controller) {
//       _setupVideoListener();
//     }
//   }

//   @override
//   void dispose() {
//     _playPauseController.dispose();
//     _likeController.dispose();
//     _pulseController.dispose();
//     _fadeController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
//   }

//   void _togglePlayPause() {
//     if (widget.controller == null) return;

//     _scaleController.forward().then((_) => _scaleController.reverse());

//     setState(() {
//       isPlaying = !isPlaying;
//     });

//     if (isPlaying) {
//       widget.controller!.play();
//       _playPauseController.forward();
//     } else {
//       widget.controller!.pause();
//       _playPauseController.reverse();
//     }

//     _showControlsTemporary();
//     HapticFeedback.lightImpact();
//   }

//   void _toggleMute() {
//     if (widget.controller == null) return;

//     setState(() {
//       isMuted = !isMuted;
//     });
//     widget.controller!.setVolume(isMuted ? 0 : 1);
//     _showControlsTemporary();
//     HapticFeedback.lightImpact();
//   }

//   void _likeVideo() {
//     setState(() {
//       isLiked = !isLiked;
//     });

//     if (isLiked) {
//       _likeController.forward();
//       _pulseController.repeat(max: 2);
//     } else {
//       _likeController.reverse();
//       _pulseController.stop();
//     }

//     HapticFeedback.mediumImpact();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isLiked ? Icons.favorite : Icons.favorite_border,
//               color: Colors.red,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(isLiked ? 'Video liked!' : 'Like removed'),
//           ],
//         ),
//         backgroundColor: Colors.grey[900],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         duration: const Duration(milliseconds: 1500),
//       ),
//     );
//   }

//   void _openComments() {
//     showCommentBottomSheet(context, postId: widget.post['pid']);
//     print(widget.post['pid']);
//   }

//   // void _bookmarkVideo() {
//   //   setState(() {
//   //     isBookmarked = !isBookmarked;
//   //   });

//   //   HapticFeedback.lightImpact();
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(
//   //       content: Row(
//   //         children: [
//   //           Icon(
//   //             isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//   //             color: Colors.orange,
//   //             size: 20,
//   //           ),
//   //           const SizedBox(width: 8),
//   //           Text(isBookmarked ? 'Video saved!' : 'Bookmark removed'),
//   //         ],
//   //       ),
//   //       backgroundColor: Colors.grey[900],
//   //       behavior: SnackBarBehavior.floating,
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //       duration: const Duration(milliseconds: 1500),
//   //     ),
//   //   );
//   // }

//   void _shareVideo() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Row(
//           children: [
//             Icon(Icons.share, color: Colors.blue, size: 20),
//             SizedBox(width: 8),
//             Text('Share options opened!'),
//           ],
//         ),
//         backgroundColor: Colors.grey[900],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         duration: const Duration(milliseconds: 1500),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isInitialized = widget.controller?.value.isInitialized ?? false;

//     return GestureDetector(
//       onTap: _showControlsTemporary,
//       child: Stack(
//         children: [
//           // Video Player
//           if (isInitialized)
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
//                   ),
//                 ),
//                 child: FittedBox(
//                   fit: BoxFit.cover,
//                   child: SizedBox(
//                     width: widget.controller!.value.size.width,
//                     height: widget.controller!.value.size.height,
//                     child: VideoPlayer(widget.controller!),
//                   ),
//                 ),
//               ),
//             )
//           else
//             Center(
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               ),
//             ),

//           // Top gradient overlay for better text visibility
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: 120,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                 ),
//               ),
//             ),
//           ),

//           // Top User Profile Section
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 16,
//             left: 16,
//             right: 100,
//             child: FadeTransition(
//               opacity: _fadeController,
//               child: Row(
//                 children: [
//                   // Profile Picture
//                   GestureDetector(
//                     onTap: () {
//                       String currentUid =
//                           FirebaseAuth.instance.currentUser!.uid;
//                       if (currentUid != null) {
//                         if (currentUid == widget.post['user']['uid']) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProfilePage(
//                                 role: widget.post['user']['role'],
//                                 uid: widget.post['user']['uid'],
//                               ),
//                             ),
//                           );
//                         } else {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProfileView(
//                                 role: widget.post['user']['role'],
//                                 uid: widget.post['user']['uid'],
//                               ),
//                             ),
//                           );
//                         }
//                       }
//                     },
//                     child: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: _getRoleColor(widget.post['role']),
//                           width: 2.5,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.3),
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: ClipOval(
//                         child:
//                             widget.post['user']['profile'] != null &&
//                                 widget.post['profile'].toString().isNotEmpty
//                             ? Image.network(
//                                 widget.post['user']['profile'],
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     _buildDefaultAvatar(),
//                               )
//                             : _buildDefaultAvatar(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // User Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Username
//                         Text(
//                           widget.post['user']['name'] ?? 'Anonymous User',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         // Role and Sport badges
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 3,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: _getRoleGradient(widget.post['role']),
//                                 ),
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: _getRoleColor(
//                                       widget.post['role'],
//                                     ).withOpacity(0.3),
//                                     blurRadius: 6,
//                                     spreadRadius: 1,
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 widget.post['role'] ?? 'User',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 3,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [Colors.orange, Colors.deepOrange],
//                                 ),
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.orange.withOpacity(0.3),
//                                     blurRadius: 6,
//                                     spreadRadius: 1,
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 widget.post['sport'] ?? 'Sports',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Follow button
//                   Material(
//                     color: Colors.transparent, // Keep background transparent
//                     borderRadius: BorderRadius.circular(20),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(20),
//                       onTap: () {
//                         print("Follow button clicked!");
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [Colors.pink, Colors.purple],
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.pink.withOpacity(0.3),
//                               blurRadius: 8,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: const Text(
//                           'Follow',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Center play/pause with scale animation
//           if (!isPlaying && isInitialized)
//             Center(
//               child: ScaleTransition(
//                 scale: Tween<double>(begin: 1.0, end: 0.9).animate(
//                   CurvedAnimation(
//                     parent: _scaleController,
//                     curve: Curves.easeInOut,
//                   ),
//                 ),
//                 child: GestureDetector(
//                   onTap: _togglePlayPause,
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.white.withOpacity(0.9),
//                           Colors.white.withOpacity(0.7),
//                         ],
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.play_arrow,
//                       color: Colors.black,
//                       size: 40,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//           // Enhanced right side actions
//           Positioned(
//             right: 16,
//             bottom: 120,
//             child: Column(
//               children: [
//                 SideActionButton(
//                   icon: isLiked ? Icons.favorite : Icons.favorite_border,
//                   label: _formatNumber(widget.post['likes'] ?? 0),
//                   onTap: _likeVideo,
//                   isActive: isLiked,
//                   activeColor: Colors.red,
//                   pulseController: isLiked ? _pulseController : null,
//                 ),
//                 const SizedBox(height: 20),
//                 SideActionButton(
//                   icon: Icons.chat_bubble_outline,
//                   label: _formatNumber(widget.post['comments'] ?? 0),
//                   onTap: _openComments,
//                   activeColor: Colors.white,
//                 ),
//                 const SizedBox(height: 20),
//                 // SideActionButton(
//                 //   icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                 //   label: 'Save',
//                 //   onTap: _bookmarkVideo,
//                 //   isActive: isBookmarked,
//                 //   activeColor: Colors.orange,
//                 // ),
//                 // const SizedBox(height: 20),
//                 // SideActionButton(
//                 //   icon: Icons.send,
//                 //   label: 'Share',
//                 //   onTap: _shareVideo,
//                 //   activeColor: Colors.blue,
//                 // ),
//               ],
//             ),
//           ),

//           // Enhanced bottom info section
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 80,
//             child: FadeTransition(
//               opacity: _fadeController,
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Colors.black.withOpacity(0.8),
//                       Colors.black.withOpacity(0.4),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Enhanced description
//                     if (widget.post['text'] != null &&
//                         widget.post['text'].isNotEmpty)
//                       Text(
//                         widget.post['text'],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           height: 1.4,
//                         ),
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                       )
//                     else
//                       Text(
//                         'Amazing ${widget.post['sport']?.toLowerCase() ?? 'sports'} content!',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           height: 1.4,
//                         ),
//                       ),

//                     const SizedBox(height: 20),

//                     // Enhanced video controls
//                     if (isInitialized)
//                       Container(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: Row(
//                           children: [
//                             const SizedBox(width: 12),
//                             GestureDetector(
//                               onTap: _togglePlayPause,
//                               child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Icon(
//                                   isPlaying ? Icons.pause : Icons.play_arrow,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Text(
//                               currentTime,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: SliderTheme(
//                                 data: SliderTheme.of(context).copyWith(
//                                   trackHeight: 3,
//                                   thumbShape: const RoundSliderThumbShape(
//                                     enabledThumbRadius: 8,
//                                   ),
//                                   overlayShape: const RoundSliderOverlayShape(
//                                     overlayRadius: 16,
//                                   ),
//                                   activeTrackColor: Colors.white,
//                                   inactiveTrackColor: Colors.white.withOpacity(
//                                     0.3,
//                                   ),
//                                   thumbColor: Colors.white,
//                                   overlayColor: Colors.white.withOpacity(0.3),
//                                 ),
//                                 child: Slider(
//                                   value: currentPosition,
//                                   onChanged: (value) {
//                                     final duration =
//                                         widget.controller!.value.duration;
//                                     final newPosition = Duration(
//                                       milliseconds:
//                                           (duration.inMilliseconds * value)
//                                               .toInt(),
//                                     );
//                                     widget.controller!.seekTo(newPosition);
//                                   },
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               totalTime,
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             GestureDetector(
//                               onTap: _toggleMute,
//                               child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Icon(
//                                   isMuted ? Icons.volume_off : Icons.volume_up,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDefaultAvatar() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: _getRoleGradient(widget.post['role'])),
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Text(
//           _getInitials(widget.post['username']),
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   String _getInitials(String? name) {
//     if (name == null || name.isEmpty) return '?';
//     List<String> nameParts = name.trim().split(' ');
//     if (nameParts.length == 1) {
//       return nameParts[0].substring(0, 1).toUpperCase();
//     } else {
//       return (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1))
//           .toUpperCase();
//     }
//   }

//   String _formatNumber(int number) {
//     if (number >= 1000000) {
//       return '${(number / 1000000).toStringAsFixed(1)}M';
//     } else if (number >= 1000) {
//       return '${(number / 1000).toStringAsFixed(1)}K';
//     }
//     return number.toString();
//   }

//   Color _getRoleColor(String? role) {
//     switch (role?.toLowerCase()) {
//       case 'athlete':
//         return Colors.blue;
//       case 'coach':
//         return Colors.green;
//       case 'sponsor':
//         return Colors.purple;
//       case 'fan':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   List<Color> _getRoleGradient(String? role) {
//     switch (role?.toLowerCase()) {
//       case 'athlete':
//         return [Colors.blue, Colors.lightBlue];
//       case 'coach':
//         return [Colors.green, Colors.lightGreen];
//       case 'sponsor':
//         return [Colors.purple, Colors.deepPurple];
//       case 'fan':
//         return [Colors.red, Colors.pink];
//       default:
//         return [Colors.grey, Colors.grey[700]!];
//     }
//   }
// }


class _ShortsPlayerWidgetState extends State<ShortsPlayerWidget>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  bool isMuted = false;
  double currentPosition = 0.0;
  String currentTime = "0:00";
  String totalTime = "0:00";
  bool isLiked = false;
  bool isBookmarked = false;
  bool _showControls = true;
  bool _isCheckingLikeStatus = true; // Add loading state

  late AnimationController _playPauseController;
  late AnimationController _likeController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();

    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _likeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _setupVideoListener();
    _startAutoHideControls();
    _checkInitialLikeStatus(); // Check like status on init
  }

  // Add this method to check initial like status
  Future<void> _checkInitialLikeStatus() async {
    if (widget.post['pid'] != null) {
      try {
        final likeStatus = await checkIfUserLikedPost(widget.post['pid']);
        if (mounted) {
          setState(() {
            isLiked = likeStatus;
            _isCheckingLikeStatus = false;
          });
          
          // If already liked, set the animation state
          if (isLiked) {
            _likeController.value = 1.0;
          }
        }
      } catch (e) {
        print('Error checking initial like status: $e');
        if (mounted) {
          setState(() {
            _isCheckingLikeStatus = false;
          });
        }
      }
    } else {
      setState(() {
        _isCheckingLikeStatus = false;
      });
    }
  }

  // Add the checkIfUserLikedPost method here
  Future<bool> checkIfUserLikedPost(String postId) async {
    try {
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUid == null) return false;

      final likeDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(currentUserUid)
          .get();

      return likeDoc.exists;
    } catch (e) {
      print('Error checking like status for post $postId: $e');
      return false;
    }
  }

  // Update the _likeVideo method to handle actual liking/unliking
  void _likeVideo() async {
    if (_isCheckingLikeStatus || widget.post['pid'] == null) return;

    // Optimistically update UI
    final wasLiked = isLiked;
    setState(() {
      isLiked = !isLiked;
    });

    if (isLiked) {
      _likeController.forward();
      // _pulseController.repeat(max: 2);
    } else {
      _likeController.reverse();
      _pulseController.stop();
    }

    HapticFeedback.mediumImpact();

    try {
      // Perform actual like/unlike operation
      await _performLikeAction(widget.post['pid'], isLiked);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(isLiked ? 'Video liked!' : 'Like removed'),
              ],
            ),
            backgroundColor: Colors.grey[900],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      // Revert UI on error
      if (mounted) {
        setState(() {
          isLiked = wasLiked;
        });
        
        if (wasLiked) {
          _likeController.forward();
        } else {
          _likeController.reverse();
          _pulseController.stop();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text('Failed to update like. Try again.'),
              ],
            ),
            backgroundColor: Colors.grey[900],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(milliseconds: 2000),
          ),
        );
      }
    }
  }

  // Add method to perform the actual like/unlike operation
  Future<void> _performLikeAction(String postId, bool shouldLike) async {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) throw Exception('User not authenticated');

    final likeDocRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(currentUserUid);

    final postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId);

    if (shouldLike) {
      // Add like
      await likeDocRef.set({
        'uid': currentUserUid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Increment like count
      await postRef.update({
        'likes': FieldValue.increment(1),
      });
    } else {
      // Remove like
      await likeDocRef.delete();
      
      // Decrement like count
      await postRef.update({
        'likes': FieldValue.increment(-1),
      });
    }
  }

  void _startAutoHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showControls) {
        _fadeController.reverse();
        setState(() => _showControls = false);
      }
    });
  }

  void _showControlsTemporary() {
    setState(() => _showControls = true);
    _fadeController.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showControls) {
        _fadeController.reverse();
        setState(() => _showControls = false);
      }
    });
  }

  void _setupVideoListener() {
    widget.controller?.addListener(() {
      if (widget.controller!.value.isInitialized && mounted) {
        final pos = widget.controller!.value.position;
        final dur = widget.controller!.value.duration;
        setState(() {
          currentPosition = dur.inMilliseconds > 0
              ? pos.inMilliseconds / dur.inMilliseconds
              : 0.0;
          currentTime = _formatDuration(pos);
          totalTime = _formatDuration(dur);
          isPlaying = widget.controller!.value.isPlaying;
        });
      }
    });
  }

  @override
  void didUpdateWidget(ShortsPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _setupVideoListener();
    }
    
    // Check like status if post changed
    if (widget.post['pid'] != oldWidget.post['pid']) {
      _checkInitialLikeStatus();
    }
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _likeController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  void _togglePlayPause() {
    if (widget.controller == null) return;

    _scaleController.forward().then((_) => _scaleController.reverse());

    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      widget.controller!.play();
      _playPauseController.forward();
    } else {
      widget.controller!.pause();
      _playPauseController.reverse();
    }

    _showControlsTemporary();
    HapticFeedback.lightImpact();
  }

  void _toggleMute() {
    if (widget.controller == null) return;

    setState(() {
      isMuted = !isMuted;
    });
    widget.controller!.setVolume(isMuted ? 0 : 1);
    _showControlsTemporary();
    HapticFeedback.lightImpact();
  }

  void _openComments() {
    showCommentBottomSheet(context, postId: widget.post['pid']);
    print(widget.post['pid']);
  }

  void _bookmarkVideo() {
    setState(() {
      isBookmarked = !isBookmarked;
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(isBookmarked ? 'Video saved!' : 'Bookmark removed'),
          ],
        ),
        backgroundColor: Colors.grey[900],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _shareVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.share, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text('Share options opened!'),
          ],
        ),
        backgroundColor: Colors.grey[900],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _navigateToProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigate to ${widget.post['username'] ?? 'User'}\'s profile',
        ),
        backgroundColor: Colors.grey[900],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = widget.controller?.value.isInitialized ?? false;

    return GestureDetector(
      onTap: _showControlsTemporary,
      child: Stack(
        children: [
          // Video Player
          if (isInitialized)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: widget.controller!.value.size.width,
                    height: widget.controller!.value.size.height,
                    child: VideoPlayer(widget.controller!),
                  ),
                ),
              ),
            )
          else
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),

          // Top gradient overlay for better text visibility
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
          ),

          // Top User Profile Section
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 100,
            child: FadeTransition(
              opacity: _fadeController,
              child: Row(
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: () {
                      String currentUid =
                          FirebaseAuth.instance.currentUser!.uid;
                      if (currentUid != null) {
                        if (currentUid == widget.post['user']['uid']) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                role: widget.post['user']['role'],
                                uid: widget.post['user']['uid'],
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileView(
                                role: widget.post['user']['role'],
                                uid: widget.post['user']['uid'],
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getRoleColor(widget.post['role']),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child:
                            widget.post['user']['profile'] != null &&
                                widget.post['profile'].toString().isNotEmpty
                            ? Image.network(
                                widget.post['user']['profile'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildDefaultAvatar(),
                              )
                            : _buildDefaultAvatar(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username
                        Text(
                          widget.post['user']['name'] ?? 'Anonymous User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Role and Sport badges
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _getRoleGradient(widget.post['role']),
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getRoleColor(
                                      widget.post['role'],
                                    ).withOpacity(0.3),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.post['role'] ?? 'User',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.orange, Colors.deepOrange],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.3),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.post['sport'] ?? 'Sports',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Follow button
                  Material(
                    color: Colors.transparent, // Keep background transparent
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        print("Follow button clicked!");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.pink, Colors.purple],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Center play/pause with scale animation
          if (!isPlaying && isInitialized)
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 0.9).animate(
                  CurvedAnimation(
                    parent: _scaleController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

          // Enhanced right side actions
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                // Show loading indicator while checking like status
                _isCheckingLikeStatus 
                  ? Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    )
                  : SideActionButton(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      label: _formatNumber(widget.post['likes'] ?? 0),
                      onTap: _likeVideo,
                      isActive: isLiked,
                      activeColor: Colors.red,
                      pulseController: isLiked ? _pulseController : null,
                    ),
                const SizedBox(height: 20),
                SideActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: _formatNumber(widget.post['comments'] ?? 0),
                  onTap: _openComments,
                  activeColor: Colors.white,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Enhanced bottom info section
          Positioned(
            bottom: 0,
            left: 0,
            right: 80,
            child: FadeTransition(
              opacity: _fadeController,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced description
                    if (widget.post['text'] != null &&
                        widget.post['text'].isNotEmpty)
                      Text(
                        widget.post['text'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        'Amazing ${widget.post['sport']?.toLowerCase() ?? 'sports'} content!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Enhanced video controls
                    if (isInitialized)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              currentTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white.withOpacity(
                                    0.3,
                                  ),
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.white.withOpacity(0.3),
                                ),
                                child: Slider(
                                  value: currentPosition,
                                  onChanged: (value) {
                                    final duration =
                                        widget.controller!.value.duration;
                                    final newPosition = Duration(
                                      milliseconds:
                                          (duration.inMilliseconds * value)
                                              .toInt(),
                                    );
                                    widget.controller!.seekTo(newPosition);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              totalTime,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _toggleMute,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  isMuted ? Icons.volume_off : Icons.volume_up,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _getRoleGradient(widget.post['role'])),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(widget.post['username']),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    } else {
      return (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1))
          .toUpperCase();
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Color _getRoleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'athlete':
        return Colors.blue;
      case 'coach':
        return Colors.green;
      case 'sponsor':
        return Colors.purple;
      case 'fan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Color> _getRoleGradient(String? role) {
    switch (role?.toLowerCase()) {
      case 'athlete':
        return [Colors.blue, Colors.lightBlue];
      case 'coach':
        return [Colors.green, Colors.lightGreen];
      case 'sponsor':
        return [Colors.purple, Colors.deepPurple];
      case 'fan':
        return [Colors.red, Colors.pink];
      default:
        return [Colors.grey, Colors.grey[700]!];
    }
  }
}