import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_ignite/model/Comment.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScaleAnimation;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _likeScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() => isLiked = !isLiked);
    
    if (isLiked) {
      _likeController.forward().then((_) => _likeController.reverse());
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(widget.comment.userAvatar),
                backgroundColor: Colors.grey[200],
                onBackgroundImageError: (_, __) {},
                child: widget.comment.userAvatar.isEmpty 
                  ? Icon(Icons.person, color: Colors.grey[400], size: 18)
                  : null,
              ),
              if (widget.comment.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1DA1F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: 12),
          
          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name and time
                Row(
                  children: [
                    Text(
                      widget.comment.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.comment.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Comment text
                Text(
                  widget.comment.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF334155),
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // // Like button
                // GestureDetector(
                //   onTap: _toggleLike,
                //   child: Row(
                //     children: [
                //       ScaleTransition(
                //         scale: _likeScaleAnimation,
                //         child: Icon(
                //           isLiked ? Icons.favorite : Icons.favorite_border,
                //           size: 16,
                //           color: isLiked ? const Color(0xFFFF6B6B) : Colors.grey[400],
                //         ),
                //       ),
                //       if (widget.comment.likes > 0 || isLiked) ...[
                //         const SizedBox(width: 4),
                //         Text(
                //           '${widget.comment.likes + (isLiked ? 1 : 0)}',
                //           style: TextStyle(
                //             fontSize: 12,
                //             color: Colors.grey[600],
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ],
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}