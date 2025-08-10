import 'package:flutter/material.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/pages/messageing.dart';
import 'package:sport_ignite/pages/notifications.dart';
import 'package:sport_ignite/pages/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sport_ignite/pages/search.dart';

class LinkedInAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool page;
  final String role;
  final VoidCallback? onTap;

  const LinkedInAppBar({
    super.key,
    required this.page,
    required this.role,
    this.onTap,
  });

  @override
  State<LinkedInAppBar> createState() => _LinkedInAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}

class _LinkedInAppBarState extends State<LinkedInAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: widget.page,
          titleSpacing: 16,
          toolbarHeight: kToolbarHeight + 10,
          leading: widget.page
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.grey[800],
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              : null,
          title: Row(
            children: [
              if (!widget.page) _buildProfileAvatar(),
              if (!widget.page) const SizedBox(width: 12),
              Expanded(child: _buildSearchBar()),
            ],
          ),
          actions: [
            _buildActionButton(
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: () => _navigateToPage(MessagingScreen()),
              hasNotification: true, // You can make this dynamic
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.notifications_none_rounded,
              onPressed: () => _navigateToPage(NotificationScreen()),
              hasNotification: true, // You can make this dynamic
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: widget.onTap ??
          () => _navigateToPage(ProfilePage(role: widget.role)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              Colors.blue[400]!,
              Colors.blue[600]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            color: Colors.white,
          ),
          child: FutureBuilder<String?>(
            future: Users().getUserProfileImage(widget.role),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.grey[100],
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                return Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                return Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.grey[200],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => _navigateToPage(SearchScreen()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: Colors.grey[500],
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Search...',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool hasNotification = false,
  }) {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.grey[700],
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
        ),
        if (hasNotification)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red[500],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}