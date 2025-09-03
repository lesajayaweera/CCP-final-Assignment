import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoViewer extends StatefulWidget {
  final List<Map<String, String>> mediaItems;
  final int initialIndex;

  const FullScreenVideoViewer({
    super.key,
    required this.mediaItems,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenVideoViewer> createState() => _FullScreenVideoViewerState();
}

class _FullScreenVideoViewerState extends State<FullScreenVideoViewer>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late int currentIndex;
  List<VideoPlayerController?> _controllers = [];
  bool _isVisible = true;
  
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex.clamp(0, widget.mediaItems.length - 1);
    _pageController = PageController(initialPage: currentIndex);
    _controllers = List.generate(widget.mediaItems.length, (_) => null);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );

    _initializeController(currentIndex);
    _startAutoHideControls();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  void _initializeController(int index) {
    if (index >= widget.mediaItems.length || _controllers[index] != null) return;

    final videoUrl = widget.mediaItems[index]['url'];
    if (videoUrl != null && videoUrl.isNotEmpty) {
      final uri = Uri.tryParse(videoUrl);

      if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
        print('Skipping invalid video URL at index $index: $videoUrl');
        return;
      }

      _controllers[index] = VideoPlayerController.networkUrl(uri)
        ..setLooping(true)
        ..initialize().then((_) {
          if (mounted && index == currentIndex) {
            setState(() {});
            _controllers[index]?.play();
          }
        }).catchError((error) {
          print('Error initializing video $index: $error');
          _controllers[index]?.dispose();
          _controllers[index] = null;
        });
    }
  }

  void _onPageChanged(int index) {
    _controllers[currentIndex]?.pause();

    setState(() {
      currentIndex = index;
    });

    if (_controllers[index] == null) {
      _initializeController(index);
    } else {
      _controllers[index]?.play();
    }

    // Preload next video
    if (index + 1 < widget.mediaItems.length && _controllers[index + 1] == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _initializeController(index + 1);
      });
    }

    // Cleanup distant controllers
    for (int i = 0; i < _controllers.length; i++) {
      if (i < index - 1 || i > index + 2) {
        if (_controllers[i] != null) {
          _controllers[i]?.dispose();
          _controllers[i] = null;
        }
      }
    }
  }

  void _toggleUI() {
    setState(() {
      _isVisible = !_isVisible;
    });
    
    if (_isVisible) {
      _fadeController.forward();
      _startAutoHideControls();
    } else {
      _fadeController.reverse();
    }
  }

  void _startAutoHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isVisible) {
        _fadeController.reverse();
        setState(() => _isVisible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.mediaItems.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _toggleUI,
                child: SimpleVideoPlayer(
                  controller: _controllers[index],
                  isActive: index == currentIndex,
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

                  // Video counter
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

          // Bottom UI (Video thumbnails - optional)
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
                          child: Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 24,
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

class SimpleVideoPlayer extends StatefulWidget {
  final VideoPlayerController? controller;
  final bool isActive;

  const SimpleVideoPlayer({
    super.key,
    required this.controller,
    required this.isActive,
  });

  @override
  State<SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  bool isMuted = false;
  double currentPosition = 0.0;
  String currentTime = "0:00";
  String totalTime = "0:00";
  bool _showControls = true;

  late AnimationController _scaleController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );

    _setupVideoListener();
    _startAutoHideControls();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
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
  void didUpdateWidget(SimpleVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _setupVideoListener();
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
    } else {
      widget.controller!.pause();
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

  @override
  Widget build(BuildContext context) {
    final isInitialized = widget.controller?.value.isInitialized ?? false;

    return GestureDetector(
      onTap: _showControlsTemporary,
      child: Stack(
        children: [
          // Video Player
          if (isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller!.value.aspectRatio,
                child: VideoPlayer(widget.controller!),
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

          // Center play/pause button
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

          // Bottom video controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
                  children: [
                    // Video controls
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
                                  inactiveTrackColor:
                                      Colors.white.withOpacity(0.3),
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
}