import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String role;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.role,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _iconAnimationControllers;
  late List<Animation<double>> _iconAnimations;
  late List<NavBarItem> items;

  @override
  void initState() {
    super.initState();
    _setupItems();
    _setupAnimations();
  }

  void _setupItems() {
    if (widget.role == 'Athlete') {
      items = [
        NavBarItem(icon: Icons.home_rounded, label: 'Home'),
        NavBarItem(icon: Icons.people_rounded, label: 'Network'),
        NavBarItem(icon: Icons.add_circle_rounded, label: 'Post', isSpecial: true),
        NavBarItem(icon: Icons.play_circle_rounded, label: 'Shorts'),
        NavBarItem(icon: Icons.sports_handball_rounded, label: 'Sponsors'),
      ];
    } else {
      items = [
        NavBarItem(icon: Icons.home_rounded, label: 'Home'),
        NavBarItem(icon: Icons.people_rounded, label: 'Network'),
        NavBarItem(icon: Icons.add_circle_rounded, label: 'Post', isSpecial: true),
        NavBarItem(icon: Icons.play_circle_rounded, label: 'Shorts'),
        NavBarItem(icon: Icons.sports_rounded, label: 'Athletes'),
      ];
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconAnimationControllers = List.generate(
      items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _iconAnimations = _iconAnimationControllers
        .map((controller) => Tween<double>(begin: 1.0, end: 1.2).animate(
              CurvedAnimation(parent: controller, curve: Curves.elasticOut),
            ))
        .toList();

    // Animate the initially selected item
    if (widget.currentIndex < _iconAnimationControllers.length) {
      _iconAnimationControllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(CustomBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Reset previous animation
      if (oldWidget.currentIndex < _iconAnimationControllers.length) {
        _iconAnimationControllers[oldWidget.currentIndex].reverse();
      }
      // Start new animation
      if (widget.currentIndex < _iconAnimationControllers.length) {
        _iconAnimationControllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _iconAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _handleTap(index),
                  child: AnimatedBuilder(
                    animation: _iconAnimations[index],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _iconAnimations[index].value,
                        child: _buildNavItem(item, isSelected, index),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavBarItem item, bool isSelected, int index) {
    if (item.isSpecial) {
      return _buildSpecialNavItem(item, isSelected);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 24,
            color: isSelected ? Colors.blue[600] : Colors.grey[600],
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.blue[600] : Colors.grey[600],
            ),
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 1),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 4 : 0,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialNavItem(NavBarItem item, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected
                    ? [Colors.blue[400]!, Colors.blue[600]!]
                    : [Colors.grey[400]!, Colors.grey[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: (isSelected ? Colors.blue : Colors.grey)
                      .withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(
              item.icon,
              size: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.blue[600] : Colors.grey[600],
            ),
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(int index) {
    widget.onTap(index);
    
    // Add haptic feedback
    // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
  }
}

class NavBarItem {
  final IconData icon;
  final String label;
  final bool isSpecial;

  const NavBarItem({
    required this.icon,
    required this.label,
    this.isSpecial = false,
  });
}