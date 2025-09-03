import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/widget/post/shorts/FullScreenVideoPlayer.dart';
import 'package:sport_ignite/widget/post/videoplayer.dart';
import 'package:sport_ignite/widget/post/widget/fullScreenImageView.dart';

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
    } else if (mediaItem['type'] == 'video') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenVideoViewer(
            mediaItems: widget.mediaItems
                .where((item) => item['type'] == 'video')
                .toList(),
            initialIndex: widget.mediaItems
                .where((item) => item['type'] == 'video')
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
