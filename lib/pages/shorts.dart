import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  PageController _pageController = PageController();
  List<Map<String, dynamic>> _videoPosts = [];
  List<VideoPlayerController?> _controllers = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final videos = await getVideoPosts();
      setState(() {
        _videoPosts = videos;
        _controllers = List.generate(videos.length, (_) => null);
        _isLoading = false;
      });
      
      // Only initialize the first video immediately
      if (videos.isNotEmpty) {
        _initializeController(0);
      }
    } catch (e) {
      print('Error loading videos: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<List<Map<String, dynamic>>> getVideoPosts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
    final videoPosts = querySnapshot.docs.where((doc) {
      final data = doc.data();
      if (data['media'] == null || (data['media'] as List).isEmpty) {
        return false;
      }
      return (data['media'] as List).any((url) {
        final lower = url.toString().toLowerCase();
        return lower.contains('.mp4') ||
               lower.contains('.mov') ||
               lower.contains('.avi') ||
               lower.contains('.mkv');
      });
    }).map((doc) {
      final postData = doc.data();
      postData['id'] = doc.id;
      return postData;
    }).toList();
    print("Video Posts Found: $videoPosts");
    return videoPosts;
  }

  void _initializeController(int index) {
  if (index >= _videoPosts.length || _controllers[index] != null) return;

  final videoUrl = _getVideoUrl(_videoPosts[index]);
  if (videoUrl != null && videoUrl.isNotEmpty) {
    final uri = Uri.tryParse(videoUrl);

    // Validate the URI
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      print('Skipping invalid video URL at index $index: $videoUrl');
      return;
    }

    _controllers[index] = VideoPlayerController.networkUrl(uri)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted && index == _currentIndex) {
          setState(() {});
          _controllers[index]?.play();
        }
      }).catchError((error) {
        print('Error initializing video $index: $error');
        // Dispose the controller if initialization fails
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

    // ✅ Validate before parsing
    if ((urlString.startsWith('http://') || urlString.startsWith('https://')) &&
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
    // Pause current video
    _controllers[_currentIndex]?.pause();
    
    setState(() {
      _currentIndex = index;
    });

    // Initialize and play new video if not already loaded
    if (_controllers[index] == null) {
      _initializeController(index);
    } else {
      _controllers[index]?.play();
    }

    // Pre-load next video only
    if (index + 1 < _videoPosts.length && _controllers[index + 1] == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _initializeController(index + 1);
      });
    }

    // Dispose videos that are too far away (keep only current and next 2)
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
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _videoPosts.isEmpty
              ? const Center(
                  child: Text(
                    'No videos found',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
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

class _ShortsPlayerWidgetState extends State<ShortsPlayerWidget>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  bool isMuted = false;
  double currentPosition = 0.0;
  String currentTime = "0:00";
  String totalTime = "0:00";
  bool isLiked = false;
  bool isBookmarked = false;

  late AnimationController _playPauseController;
  late AnimationController _likeController;

  @override
  void initState() {
    super.initState();

    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _likeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _setupVideoListener();
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
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _likeController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  void _togglePlayPause() {
    if (widget.controller == null) return;

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

    HapticFeedback.lightImpact();
  }

  void _toggleMute() {
    if (widget.controller == null) return;

    setState(() {
      isMuted = !isMuted;
    });
    widget.controller!.setVolume(isMuted ? 0 : 1);
    HapticFeedback.lightImpact();
  }

  void _likeVideo() {
    setState(() {
      isLiked = !isLiked;
    });
    
    if (isLiked) {
      _likeController.forward();
    } else {
      _likeController.reverse();
    }

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isLiked ? 'Video liked!' : 'Like removed')),
    );
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Comments (${widget.post['comments'] ?? 0})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 10,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[700],
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      'User ${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Amazing ${widget.post['sport']?.toLowerCase() ?? 'sports'} content!',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _bookmarkVideo() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isBookmarked ? 'Video bookmarked!' : 'Bookmark removed')),
    );
  }

  void _shareVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share options opened!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = widget.controller?.value.isInitialized ?? false;
    
    return Stack(
      children: [
        // Video Player
        if (isInitialized)
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePlayPause,
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
          const Center(child: CircularProgressIndicator()),

        // Center play icon when paused
        if (!isPlaying && isInitialized)
          Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),

        // Right side actions (TikTok style)
        Positioned(
          right: 16,
          bottom: 120,
          child: Column(
            children: [
              _SideActionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                label: '${widget.post['likes'] ?? 0}',
                onTap: _likeVideo,
                isActive: isLiked,
              ),
              const SizedBox(height: 20),
              _SideActionButton(
                icon: Icons.chat_bubble_outline,
                label: '${widget.post['comments'] ?? 0}',
                onTap: _openComments,
              ),
              const SizedBox(height: 20),
              _SideActionButton(
                icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                label: 'Save',
                onTap: _bookmarkVideo,
                isActive: isBookmarked,
              ),
              const SizedBox(height: 20),
              _SideActionButton(
                icon: Icons.send,
                label: 'Share',
                onTap: _shareVideo,
              ),
            ],
          ),
        ),

        // Bottom info section
        Positioned(
          bottom: 0,
          left: 0,
          right: 80, // Leave space for right side actions
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(widget.post['role']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.post['role'] ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.post['sport'] ?? 'Sports',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                if (widget.post['text'] != null && widget.post['text'].isNotEmpty)
                  Text(
                    widget.post['text'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text(
                    'Amazing ${widget.post['sport']?.toLowerCase() ?? 'sports'} content!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),

                const SizedBox(height: 16),

                // Video controls
                if (isInitialized)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                          ),
                          child: Slider(
                            value: currentPosition,
                            onChanged: (value) {
                              final duration = widget.controller!.value.duration;
                              final newPosition = Duration(
                                milliseconds: (duration.inMilliseconds * value).toInt(),
                              );
                              widget.controller!.seekTo(newPosition);
                            },
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$currentTime / $totalTime",
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _toggleMute,
                        child: Icon(
                          isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
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
}

class _SideActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _SideActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.red : Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}