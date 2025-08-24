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
    // Enhanced color logic for better visibility of liked state
    final bool isLikeButton = widget.label == 'Like';
    final Color activeColor = widget.color ?? const Color(0xFFFF6B6B);
    final Color inactiveColor = const Color(0xFF64748B);
    
    final Color currentColor = widget.isActive ? activeColor : inactiveColor;
    final Color backgroundColor = widget.isActive 
        ? activeColor.withOpacity(0.15) 
        : Colors.grey[50]!;
    final Color borderColor = widget.isActive 
        ? activeColor.withOpacity(0.3) 
        : Colors.grey[200]!;

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
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: widget.isActive ? 1.5 : 1,
            ),
            // Add subtle shadow for active state
            boxShadow: widget.isActive ? [
              BoxShadow(
                color: activeColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: currentColor,
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  color: currentColor,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}