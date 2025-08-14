import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ShortsPlayerScreen extends StatefulWidget {
  const ShortsPlayerScreen({super.key});

  @override
  State<ShortsPlayerScreen> createState() => _ShortsPlayerScreenState();
}

class _ShortsPlayerScreenState extends State<ShortsPlayerScreen>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  bool isMuted = false;
  double currentPosition = 0.0;
  String currentTime = "0:00";
  String totalTime = "0:00";

  late AnimationController _playPauseController;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _videoController =
        VideoPlayerController.asset('asset/video/temp.mp4')
          ..initialize().then((_) {
            setState(() {
              totalTime = _formatDuration(_videoController.value.duration);
            });
          });
    _videoController.setLooping(true);

    _videoController.addListener(() {
      if (_videoController.value.isInitialized) {
        final pos = _videoController.value.position;
        final dur = _videoController.value.duration;
        setState(() {
          currentPosition = pos.inMilliseconds / dur.inMilliseconds;
          currentTime = _formatDuration(pos);
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _playPauseController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _videoController.play();
      _playPauseController.forward();
    } else {
      _videoController.pause();
      _playPauseController.reverse();
    }

    HapticFeedback.lightImpact();
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    _videoController.setVolume(isMuted ? 0 : 1);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: Stack(
        children: [
          _videoController.value.isInitialized
              ? Positioned.fill(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController.value.size.width,
                        height: _videoController.value.size.height,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),

          
          // Center play icon when paused
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
                  // Description and "see more"
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amazing swim training session!',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {},
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
                            thumbShape:
                                const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape:
                                const RoundSliderOverlayShape(overlayRadius: 12),
                          ),
                          child: Slider(
                            value: currentPosition,
                            onChanged: (value) {
                              final duration = _videoController.value.duration;
                              final newPosition =
                                  Duration(milliseconds: (duration.inMilliseconds * value).toInt());
                              _videoController.seekTo(newPosition);
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

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(icon: Icons.thumb_up_outlined, onTap: _likeVideo),
                      _ActionButton(icon: Icons.chat_bubble_outline, onTap: _openComments),
                      _ActionButton(icon: Icons.bookmark_border, onTap: _bookmarkVideo),
                      _ActionButton(icon: Icons.send, onTap: _shareVideo),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

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
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';

// class ShortsPlayerScreen extends StatefulWidget {
//   const ShortsPlayerScreen({Key? key}) : super(key: key);

//   @override
//   State<ShortsPlayerScreen> createState() => _ShortsPlayerScreenState();
// }

// class _ShortsPlayerScreenState extends State<ShortsPlayerScreen>
//     with TickerProviderStateMixin {
//   bool isPlaying = false;
//   bool isMuted = false;
//   double currentPosition = 0.0;
//   String currentTime = "0:00";
//   String totalTime = "0:00";

//   late AnimationController _playPauseController;
//   late VideoPlayerController _videoController;

//   @override
//   void initState() {
//     super.initState();

//     _playPauseController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _videoController = VideoPlayerController.asset('asset/video/temp.mp4')
//       ..initialize().then((_) {
//         setState(() {
//           totalTime = _formatDuration(_videoController.value.duration);
//         });
//       });

//     _videoController.setLooping(true);

//     _videoController.addListener(() {
//       if (_videoController.value.isInitialized) {
//         final pos = _videoController.value.position;
//         final dur = _videoController.value.duration;
//         setState(() {
//           currentPosition = pos.inMilliseconds / dur.inMilliseconds;
//           currentTime = _formatDuration(pos);
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _playPauseController.dispose();
//     super.dispose();
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
//   }

//   void _togglePlayPause() {
//     setState(() {
//       isPlaying = !isPlaying;
//     });

//     if (isPlaying) {
//       _videoController.play();
//       _playPauseController.forward();
//     } else {
//       _videoController.pause();
//       _playPauseController.reverse();
//     }

//     HapticFeedback.lightImpact();
//   }

//   void _toggleMute() {
//     setState(() {
//       isMuted = !isMuted;
//     });
//     _videoController.setVolume(isMuted ? 0 : 1);
//     HapticFeedback.lightImpact();
//   }

//   void _showMoreOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.grey[900],
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.report_outlined, color: Colors.white),
//               title: const Text('Report', style: TextStyle(color: Colors.white)),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.block_outlined, color: Colors.white),
//               title: const Text('Block', style: TextStyle(color: Colors.white)),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.download_outlined, color: Colors.white),
//               title: const Text('Download', style: TextStyle(color: Colors.white)),
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _likeVideo() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Video liked!')),
//     );
//   }

//   void _openComments() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.grey[900],
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         maxChildSize: 0.9,
//         minChildSize: 0.3,
//         builder: (context, scrollController) => Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const Text(
//                 'Comments',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   controller: scrollController,
//                   itemCount: 10,
//                   itemBuilder: (context, index) => ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.grey[700],
//                       child: Text('$index'),
//                     ),
//                     title: Text(
//                       'User $index',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     subtitle: Text(
//                       'Great swimming technique!',
//                       style: TextStyle(color: Colors.grey[400]),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _bookmarkVideo() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Video bookmarked!')),
//     );
//   }

//   void _shareVideo() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Share options opened!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _videoController.value.isInitialized
//             ? Positioned.fill(
//                 child: GestureDetector(
//                   onTap: _togglePlayPause,
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _videoController.value.size.width,
//                       height: _videoController.value.size.height,
//                       child: VideoPlayer(_videoController),
//                     ),
//                   ),
//                 ),
//               )
//             : const Center(child: CircularProgressIndicator()),

//         // Center play icon when paused
//         if (!isPlaying)
//           Center(
//             child: GestureDetector(
//               onTap: _togglePlayPause,
//               child: Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.play_arrow,
//                   color: Colors.white,
//                   size: 40,
//                 ),
//               ),
//             ),
//           ),

//         // Bottom controls
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//                 colors: [
//                   Colors.black.withOpacity(0.8),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Description and "see more"
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Amazing swim training session!',
//                         style: TextStyle(color: Colors.white, fontSize: 14),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       GestureDetector(
//                         onTap: () {},
//                         child: Text(
//                           'See more',
//                           style: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Video controls
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: Icon(
//                         isPlaying ? Icons.pause : Icons.play_arrow,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: SliderTheme(
//                         data: SliderTheme.of(context).copyWith(
//                           trackHeight: 2,
//                           thumbShape:
//                               const RoundSliderThumbShape(enabledThumbRadius: 6),
//                           overlayShape:
//                               const RoundSliderOverlayShape(overlayRadius: 12),
//                         ),
//                         child: Slider(
//                           value: currentPosition,
//                           onChanged: (value) {
//                             final duration = _videoController.value.duration;
//                             final newPosition = Duration(
//                                 milliseconds:
//                                     (duration.inMilliseconds * value).toInt());
//                             _videoController.seekTo(newPosition);
//                           },
//                           activeColor: Colors.white,
//                           inactiveColor: Colors.white.withOpacity(0.3),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "$currentTime / $totalTime",
//                       style: const TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                     const SizedBox(width: 16),
//                     GestureDetector(
//                       onTap: _toggleMute,
//                       child: Icon(
//                         isMuted ? Icons.volume_off : Icons.volume_up,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _ActionButton(icon: Icons.thumb_up_outlined, onTap: _likeVideo),
//                     _ActionButton(icon: Icons.chat_bubble_outline, onTap: _openComments),
//                     _ActionButton(icon: Icons.bookmark_border, onTap: _bookmarkVideo),
//                     _ActionButton(icon: Icons.send, onTap: _shareVideo),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;

//   const _ActionButton({required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.2),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, color: Colors.white, size: 24),
//       ),
//     );
//   }
// }
