import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Enhanced Video Player Widget
class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool showControls;
  final double aspectRatio;

  const VideoPlayerWidget({
    super.key,
    required this.url,
    this.showControls = true,
    this.aspectRatio = 1/1,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;

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
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: widget.showControls ? 32 : 24,
                    color: Colors.red[400],
                  ),
                ),
                if (widget.showControls) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Failed to load video',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: const Color(0xFF667eea),
                  strokeWidth: widget.showControls ? 3 : 2,
                ),
                if (widget.showControls) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Loading video...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: GestureDetector(
        onTap: widget.showControls ? () {
          setState(() {
            _showControls = !_showControls;
          });
        } : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller!),
            
            // Gradient overlay for better control visibility
            if (_showControls && widget.showControls)
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    radius: 0.8,
                  ),
                ),
              ),
            
            // Play/Pause button
            if (_showControls && widget.showControls)
              AnimatedScale(
                scale: _controller!.value.isPlaying ? 0.8 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      });
                    },
                    child: Icon(
                      _controller!.value.isPlaying 
                          ? Icons.pause_rounded 
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            
            // Video duration indicator
            if (widget.showControls)
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatDuration(_controller!.value.duration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            
            // Video indicator icon for thumbnails
            if (!widget.showControls)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}