import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_ignite/model/Comment.dart';
import 'package:sport_ignite/model/postService.dart';
import 'package:sport_ignite/widget/post/widget/commentTile.dart';

// Main function to show comment bottom sheet
void showCommentBottomSheet(BuildContext context, {String? postId}) {
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
      child: CommentBottomSheet(postId: postId),
    ),
  );
}

class CommentBottomSheet extends StatefulWidget {
  final String? postId;
 

  const CommentBottomSheet({
    super.key,
    this.postId,
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

  
  // void _sendComment() async {
  //   if (_controller.text.trim().isEmpty) return;
    
  //   setState(() => isSending = true);
    
  //   final commentText = _controller.text.trim();
  //   _controller.clear();
    
  //   // Simulate sending delay
  //   await Future.delayed(const Duration(milliseconds: 500));
    
  //   setState(() {
  //     comments.insert(0, Comment(
  //       id: DateTime.now().toString(),
  //       userName: 'You',
  //       userAvatar: 'https://i.pravatar.cc/150?img=10',
  //       comment: commentText,
  //       timeAgo: 'now',
  //       likes: 0,
  //       isCurrentUser: true,
  //     ));
  //     isSending = false;
  //   });
    
  //   HapticFeedback.lightImpact();
  //   _focusNode.requestFocus();
  // }

  void _sendComment() async {
  if (_controller.text.trim().isEmpty) return;

  setState(() => isSending = true);

  final commentText = _controller.text.trim();
  _controller.clear();

  try {
    await PostService.addComment(
      postId: widget.postId!, // from widget
      commentText: commentText,
      context: context,
    );

    HapticFeedback.lightImpact();
    _focusNode.requestFocus();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding comment: $e')),
    );
  } finally {
    setState(() => isSending = false);
  }
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
              
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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

      final docs = snapshot.data!.docs;

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final data = docs[index].data() as Map<String, dynamic>;

          return CommentTile(
            comment: Comment(
              id: docs[index].id,
              userName: data['username'] ?? 'Unknown',
              userAvatar: data['userAvatar'] ?? '', // optional: fetch from user profile later
              comment: data['text'] ?? '',
              timeAgo: _formatTime(data['timestamp']),
              likes: 0,
              isCurrentUser: data['uid'] == FirebaseAuth.instance.currentUser!.uid,
            ),
          );
        },
      );
    },
  );
}

String _formatTime(Timestamp? timestamp) {
  if (timestamp == null) return 'now';
  final date = timestamp.toDate();
  final diff = DateTime.now().difference(date);

  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
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

