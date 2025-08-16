import 'package:flutter/material.dart';
import 'package:sport_ignite/model/Athlete.dart';
import 'package:sport_ignite/model/ConnectionService.dart';
import 'package:sport_ignite/model/Sponsor.dart';
import 'package:sport_ignite/pages/manageInvititations.dart';
import 'package:sport_ignite/pages/myNetwork.dart';
import 'package:sport_ignite/pages/profileView.dart';

class NetworkManagementScreen extends StatefulWidget {
  final String role;
  const NetworkManagementScreen({super.key, required this.role});

  @override
  State<NetworkManagementScreen> createState() =>
      _NetworkManagementScreenState();
}

class _NetworkManagementScreenState extends State<NetworkManagementScreen>
    with TickerProviderStateMixin {
  int selectedBottomNavIndex = 1;
  String currentView = 'network';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Convert Firebase data to UsercardDetails
  List<UsercardDetails> _convertFirebaseDataToUserCards(
    List<Map<String, dynamic>> data,
  ) {
    return data.map((item) {
      // Handle both athlete and sponsor data structures
      String uid = item['uid'] ?? '';
      String name = item['name'] ?? 'Unknown';
      String role = item['role'] ?? 'Unknown Role';
      String company = '';
      String role2 = '';
      String imagePath = item['profile'] ?? '';

      if (widget.role == 'Athlete') {
        // If current user is athlete, show sponsors
        company = item['institute'] ?? 'Unknown Institute';
        role2 = '${item['sport'] ?? 'Unknown Sport'} Athlete';
      } else {
        // If current user is sponsor, show athletes
        company = item['company'] ?? 'Unknown Company';
        role2 = '${item['orgStructure'] ?? 'Private'} Sponsor';
      }

      return UsercardDetails(
        uid: uid,
        name: name,
        role: role,
        role2: role2,
        company: company,
        imagePath: imagePath,
      );
    }).toList();
  }

  // Get the appropriate stream based on user role
  Stream<List<Map<String, dynamic>>> _getRelevantStream() {
    if (widget.role == 'Athlete') {
      // If user is athlete, show sponsors
      return Athlete.getAllAthletesStream();
    } else {
      // If user is sponsor, show athletes
      return Sponsor.getAllSponsorsStream();
    }
  }

  // Get the display text for the section
  String _getSectionTitle() {
    if (widget.role == 'Athlete') {
      return 'Athletes You May Know';
    } else {
      return 'Sponsors You May Know';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = (width / 200).floor();
    final childAspectRatio =
        width / (crossAxisCount * 250); // adjust height ratio

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(opacity: _fadeAnimation, child: _buildNetworkView()),
    );
  }

  Widget _buildNetworkView() {
    return CustomScrollView(
      slivers: [
        // Enhanced navigation section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildEnhancedNavOption(
                  icon: Icons.people_outline_rounded,
                  title: 'Manage my network',
                  subtitle: 'View and organize your connections',
                  onTap: () => _navigateTo('manage_network'),
                  color: const Color(0xFF3B82F6),
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.1),
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<int>(
                  stream: ConnectionService.pendingRequestsCountStream(),
                  builder: (context, snapshot) {
                    int count = snapshot.data ?? 0;
                    return _buildEnhancedNavOption(
                      icon: Icons.mail_outline_rounded,
                      title: 'Invitation requests',
                      subtitle: '$count pending invitations',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvitationsScreen(),
                          ),
                        );
                      },
                      hasNotification: count > 0,
                      notificationCount: count,
                      color: const Color(0xFF10B981),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Enhanced dynamic section with StreamBuilder
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getSectionTitle(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F2937),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Expand your network with these suggestions',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // StreamBuilder for dynamic data
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _getRelevantStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading data',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No suggestions available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final userCards = _convertFirebaseDataToUserCards(
                      snapshot.data!,
                    );

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: userCards.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: Duration(
                              milliseconds: 300 + (index * 100),
                            ),
                            curve: Curves.easeOutBack,
                            child: EnhancedUserCard(
                              user: userCards[index],
                              onConnect: () =>
                                  _connectWithUser(userCards[index]),
                              onDismiss: () =>
                                  _dismissUser(index, userCards[index]),
                              index: index,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedNavOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool hasNotification = false,
    int notificationCount = 0,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasNotification && notificationCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(String route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyNetworkScreen(role: widget.role),
      ),
    );
  }

  void _connectWithUser(UsercardDetails user) {
    ConnectionService.sendConnectionRequestUsingUID(context, user.uid);
  }

  void _dismissUser(int index, UsercardDetails user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.visibility_off, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('${user.name} dismissed'),
          ],
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6B7280),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class EnhancedUserCard extends StatefulWidget {
  final UsercardDetails user;
  final VoidCallback onConnect;
  final VoidCallback onDismiss;
  final int index;

  const EnhancedUserCard({
    super.key,
    required this.user,
    required this.onConnect,
    required this.onDismiss,
    required this.index,
  });

  @override
  State<EnhancedUserCard> createState() => _EnhancedUserCardState();
}

class _EnhancedUserCardState extends State<EnhancedUserCard>
    with SingleTickerProviderStateMixin {
  final bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () {
          print(widget.user.uid);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfileView(uid: widget.user.uid, role: widget.user.role),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFF3B82F6)
                  : Colors.grey.shade200,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.04),
                blurRadius: _isHovered ? 15 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Enhanced profile image with gradient border
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF3B82F6).withOpacity(0.8),
                            const Color(0xFF8B5CF6).withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: widget.user.imagePath.isNotEmpty
                              ? Image.network(
                                  widget.user.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Name
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Role
                    Text(
                      widget.user.role2,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Company/Institute
                    Text(
                      widget.user.company,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    const Spacer(),

                    // Enhanced Connect Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _scaleController.forward().then((_) {
                              _scaleController.reverse();
                              widget.onConnect();
                            });
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Connect',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced dismiss button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: widget.onDismiss,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UsercardDetails {
  final String uid;
  final String name;
  final String role;
  final String role2;
  final String company;
  final String imagePath;

  UsercardDetails({
    required this.uid,
    required this.name,
    required this.role,
    required this.role2,
    required this.company,
    required this.imagePath,
  });
}
