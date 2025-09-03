import 'package:flutter/material.dart';
class SideActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Color activeColor;
  final AnimationController? pulseController;

  const SideActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.activeColor = Colors.white,
    this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Pulse effect for likes
              if (pulseController != null && isActive)
                AnimatedBuilder(
                  animation: pulseController!,
                  builder: (context, child) {
                    return Container(
                      width: 56 + (pulseController!.value * 20),
                      height: 56 + (pulseController!.value * 20),
                      decoration: BoxDecoration(
                        color: activeColor.withOpacity(0.3 - (pulseController!.value * 0.3)),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              // Main button
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: activeColor.withOpacity(0.5), width: 2) : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: isActive ? activeColor : Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}