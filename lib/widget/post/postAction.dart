import 'package:flutter/material.dart';

// Final PostActions Component
class PostActions extends StatelessWidget {
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSend;
  final bool isLiked;
  final Animation<double> likeAnimation;

  const PostActions({
    super.key,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSend,
    this.isLiked = false,
    required this.likeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ScaleTransition(
          scale: likeAnimation,
          child: _ActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            label: 'Like',
            onTap: onLike,
            color: isLiked ? const Color(0xFFFF6B6B) : null,
            isActive: isLiked,
          ),
        ),
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: 'Comment',
          onTap: onComment,
        ),
        _ActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: onShare,
        ),
        _ActionButton(
          icon: Icons.send_outlined,
          label: 'Send',
          onTap: onSend,
        ),
      ],
    );
  }
}

// Action Button Helper Widget
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
    this.isActive = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.color?.withOpacity(0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isActive
                  ? widget.color?.withOpacity(0.3) ?? Colors.grey[200]!
                  : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.color ?? const Color(0xFF64748B),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.color ?? const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}