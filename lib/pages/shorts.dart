import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortsPlayerScreen extends StatefulWidget {
  const ShortsPlayerScreen({Key? key}) : super(key: key);

  @override
  State<ShortsPlayerScreen> createState() => _ShortsPlayerScreenState();
}

class _ShortsPlayerScreenState extends State<ShortsPlayerScreen>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  bool isMuted = false;
  double currentPosition = 0.3; // 30% of video played
  String currentTime = "0:06";
  String totalTime = "0:20";
  
  late AnimationController _playPauseController;

  @override
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video content (using placeholder image)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/swimming_video.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Top app bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Shorts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _showMoreOptions,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _shareVideo,
                  ),
                ],
              ),
            ),
          ),
          
          // Center play/pause overlay
          if (!isPlaying)
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
          
          // Tap to play/pause gesture detector
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
                children: [
                  // Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            // Show more description
                          },
                          child: Text(
                            'See more',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Video controls
                  Row(
                    children: [
                      // Play/Pause button
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Progress bar
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
                              setState(() {
                                currentPosition = value;
                                // Update current time based on position
                                int seconds = (value * 20).round();
                                currentTime = "0:${seconds.toString().padLeft(2, '0')}";
                              });
                            },
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Time display
                      Text(
                        currentTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Mute/Unmute button
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
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: Icons.thumb_up_outlined,
                        onTap: _likeVideo,
                      ),
                      _ActionButton(
                        icon: Icons.chat_bubble_outline,
                        onTap: _openComments,
                      ),
                      _ActionButton(
                        icon: Icons.bookmark_border,
                        onTap: _bookmarkVideo,
                      ),
                      _ActionButton(
                        icon: Icons.send,
                        onTap: _shareVideo,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
    
    if (isPlaying) {
      _playPauseController.forward();
    } else {
      _playPauseController.reverse();
    }
    
    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    HapticFeedback.lightImpact();
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report_outlined, color: Colors.white),
              title: const Text('Report', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined, color: Colors.white),
              title: const Text('Block', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined, color: Colors.white),
              title: const Text('Download', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _likeVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video liked!')),
    );
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Comments',
                style: TextStyle(
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
                      child: Text('$index'),
                    ),
                    title: Text(
                      'User $index',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Great swimming technique!',
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video bookmarked!')),
    );
  }

  void _shareVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share options opened!')),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

// Demo usage
