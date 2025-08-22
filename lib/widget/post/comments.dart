import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Main function to show comment bottom sheet
void showCommentBottomSheet(BuildContext context, {String? postId, int comments = 0}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    isDismissible: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommentBottomSheet(postId: postId, comments: comments),
    ),
  );
}

class CommentBottomSheet extends StatefulWidget {
  final String? postId;
  final int comments;

  const CommentBottomSheet({
    super.key,
    this.postId,
    this.comments = 0,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isSending = false;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _loadMockComments();
    
    // Auto-focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _focusNode.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadMockComments() {
    setState(() {
      comments = [
        Comment(
          id: '1',
          userName: 'Alex Rodriguez',
          userAvatar: 'https://i.pravatar.cc/150?img=1',
          comment: 'Amazing performance! Keep it up! 🔥',
          timeAgo: '2m',
          likes: 5,
          isVerified: true,
        ),
        Comment(
          id: '2',
          userName: 'Sarah Johnson',
          userAvatar: 'https://i.pravatar.cc/150?img=2',
          comment: 'This is so inspiring! What training routine do you follow?',
          timeAgo: '5m',
          likes: 12,
        ),
        Comment(
          id: '3',
          userName: 'Mike Chen',
          userAvatar: 'https://i.pravatar.cc/150?img=3',
          comment: 'Incredible technique! 💪',
          timeAgo: '10m',
          likes: 3,
        ),
      ];
    });
  }

  void _sendComment() async {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() => isSending = true);
    
    final commentText = _controller.text.trim();
    _controller.clear();
    
    // Simulate sending delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      comments.insert(0, Comment(
        id: DateTime.now().toString(),
        userName: 'You',
        userAvatar: 'https://i.pravatar.cc/150?img=10',
        comment: commentText,
        timeAgo: 'now',
        likes: 0,
        isCurrentUser: true,
      ));
      isSending = false;
    });
    
    HapticFeedback.lightImpact();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Comments list
            Expanded(
              child: _buildCommentsList(),
            ),
            
            // Comment input
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '${comments.length}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (comments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No comments yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share your thoughts!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return CommentTile(comment: comment);
      },
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // User avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF667eea),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Text input
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 100),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendComment(),
                  onChanged: (text) => setState(() {}),
                  onTap: () => _focusNode.requestFocus(),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Send button
            GestureDetector(
              onTap: isSending ? null : _sendComment,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _controller.text.trim().isNotEmpty 
                    ? const Color(0xFF667eea) 
                    : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: _controller.text.trim().isNotEmpty 
                          ? Colors.white 
                          : Colors.grey[600],
                        size: 18,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Comment Tile Widget
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
                
                // Like button
                GestureDetector(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _likeScaleAnimation,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: isLiked ? const Color(0xFFFF6B6B) : Colors.grey[400],
                        ),
                      ),
                      if (widget.comment.likes > 0 || isLiked) ...[
                        const SizedBox(width: 4),
                        Text(
                          '${widget.comment.likes + (isLiked ? 1 : 0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Comment Model
class Comment {
  final String id;
  final String userName;
  final String userAvatar;
  final String comment;
  final String timeAgo;
  final int likes;
  final bool isVerified;
  final bool isCurrentUser;

  Comment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.comment,
    required this.timeAgo,
    this.likes = 0,
    this.isVerified = false,
    this.isCurrentUser = false,
  });
}