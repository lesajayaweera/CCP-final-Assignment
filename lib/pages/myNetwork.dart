import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport_ignite/model/ConnectionService.dart';
import 'package:sport_ignite/model/MessagingService.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/pages/profileView.dart';

// Add your UserService import here
// import 'path/to/your/user_service.dart';

class MyNetworkScreen extends StatefulWidget {
  final String role;
  
  const MyNetworkScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<MyNetworkScreen> createState() => _MyNetworkScreenState();
}

class _MyNetworkScreenState extends State<MyNetworkScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<NetworkConnection> pendingRequests = [];
  List<NetworkConnection> activeConnections = [];
  List<NetworkConnection> sentRequests = [];
  
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _loadNetworkData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadNetworkData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load both active connections and sent requests in parallel
      final futures = await Future.wait([
        Users.getConnectedUsers(),
        ConnectionService.getSentPendingRequests(),
      ]);

      final connectedUsersData = futures[0] as List<Map<String, dynamic>>;
      final sentRequestsData = futures[1] as List<Map<String, dynamic>>;

      // Convert connected users to NetworkConnection objects
      activeConnections = connectedUsersData.map((userData) {
        return NetworkConnection(
          id: userData['uid'] ?? '',
          name: userData['name'] ?? 'Unknown User',
          role: userData['role'] ?? '',
          sport: _getSportFromUserData(userData),
          location: _getLocationFromUserData(userData),
          imagePath: userData['profile'] ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          status: 'active',
          connectedDate: DateTime.now(),
          requestId: null, // No request ID for active connections
        );
      }).toList();

      // Convert sent requests to NetworkConnection objects
      sentRequests = sentRequestsData.map((userData) {
        return NetworkConnection(
          id: userData['uid'] ?? '',
          name: userData['name'] ?? 'Unknown User',
          role: userData['role'] ?? '',
          sport: _getSportFromUserData(userData),
          location: _getLocationFromUserData(userData),
          imagePath: userData['profile'] ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          status: 'sent',
          connectedDate: userData['requestTimestamp']?.toDate() ?? DateTime.now(),
          requestId: userData['requestId'], // Store request ID for cancellation
        );
      }).toList();

    } catch (e) {
      print("Error loading network data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('Failed to load connections: ${e.toString()}'),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }

    setState(() {
      isLoading = false;
    });

    _animationController.forward();
  }

  // Helper method to extract sport information from user data
  String _getSportFromUserData(Map<String, dynamic> userData) {
    if (userData['role'] == 'Athlete') {
      return userData['sport'] ?? 'Unknown Sport';
    } else if (userData['role'] == 'Sponsor') {
      return userData['sportIntrested'] ?? 'Unknown Sport';
    } else {
      // Handle other roles like Coach, etc.
      return userData['sport'] ?? userData['sportIntrested'] ?? 'Unknown Sport';
    }
  }

  // Helper method to extract location information from user data
  String _getLocationFromUserData(Map<String, dynamic> userData) {
    String city = userData['city'] ?? '';
    String province = userData['province'] ?? '';
    
    if (city.isNotEmpty && province.isNotEmpty) {
      return '$city, $province';
    } else if (city.isNotEmpty) {
      return city;
    } else if (province.isNotEmpty) {
      return province;
    } else {
      return 'Unknown Location';
    }
  }

  // Add refresh functionality
  Future<void> _refreshData() async {
    await _loadNetworkData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveTab(),
                  _buildSentTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.people_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Network',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your professional connections',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatsCard('Active', activeConnections.length, Icons.handshake),
                const SizedBox(width: 12),
                _buildStatsCard('Sent', sentRequests.length, Icons.send),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String label, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 16),
                SizedBox(width: 4),
                Text('Active'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, size: 16),
                SizedBox(width: 4),
                Text('Sent'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    if (isLoading) return _buildLoadingState();
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'My Connections (${activeConnections.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: activeConnections.isEmpty
                ? _buildEmptyState('No active connections', 'Start building your network!', Icons.people_outline)
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      itemCount: activeConnections.length,
                      itemBuilder: (context, index) {
                        return _buildActiveConnectionCard(activeConnections[index], index);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentTab() {
    if (isLoading) return _buildLoadingState();
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Sent Requests (${sentRequests.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: sentRequests.isEmpty
                ? _buildEmptyState('No sent requests', 'Send connection requests to build your network!', Icons.send_rounded)
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      itemCount: sentRequests.length,
                      itemBuilder: (context, index) {
                        return _buildSentConnectionCard(sentRequests[index], index);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveConnectionCard(NetworkConnection connection, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(uid: connection.id, role: connection.role)));
          },
          child: Row(
            children: [
              // Profile Image with active indicator
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            connection.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.person, size: 30, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.check, size: 8, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          connection.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            connection.role,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.sports_tennis, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          connection.sport,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            connection.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Message Button
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    MessagingService.startNewChat(context, connection.id);
                  },
                  icon: const Icon(Icons.message_rounded, color: Color(0xFF667eea), size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSentConnectionCard(NetworkConnection connection, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Profile Image with pending indicator
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          connection.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.person, size: 30, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.schedule, size: 8, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        connection.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          connection.role,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFF59E0B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.sports_tennis, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        connection.sport,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: 10,                      
                            color: Color(0xFFF59E0B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Cancel Button with loading state
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => _cancelRequest(connection),
                icon: const Icon(Icons.close, color: Color(0xFFEF4444), size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading your network...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 50,
              color: const Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _messageConnection(NetworkConnection connection) {
    // Implement messaging logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.message, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Opening chat with ${connection.name}...'),
          ],
        ),
        backgroundColor: const Color(0xFF667eea),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _cancelRequest(NetworkConnection connection) async {
    // Show confirmation dialog first
    final bool? shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: Text('Are you sure you want to cancel the connection request to ${connection.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (shouldCancel != true) return;

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Cancelling request...'),
          ],
        ),
        backgroundColor: Color(0xFF667eea),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Use the Firebase method to cancel the request
      if (connection.requestId != null) {
        final success = await ConnectionService.cancelConnectionRequest(connection.requestId!);
        
        if (success) {
          // Remove from local list and update UI
          setState(() {
            sentRequests.remove(connection);
          });
          
          // Hide the loading snackbar and show success message
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Request to ${connection.name} cancelled successfully'),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          throw Exception('Failed to cancel request');
        }
      } else {
        throw Exception('Request ID not found');
      }
    } catch (e) {
      print("Error cancelling request: $e");
      
      // Hide loading snackbar and show error message
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Failed to cancel request: ${e.toString()}'),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
// Network Connection Model
class NetworkConnection {
  final String id;
  final String name;
  final String role;
  final String sport;
  final String location;
  final String imagePath;
  String status;
  final DateTime connectedDate;
  final String? requestId; // Add this field to store request ID for cancellation

  NetworkConnection({
    required this.id,
    required this.name,
    required this.role,
    required this.sport,
    required this.location,
    required this.imagePath,
    required this.status,
    required this.connectedDate,
    this.requestId, // Make it optional
  });

  factory NetworkConnection.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NetworkConnection(
      id: doc.id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      sport: data['sport'] ?? '',
      location: data['location'] ?? '',
      imagePath: data['imagePath'] ?? '',
      status: data['status'] ?? '',
      connectedDate: (data['connectedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      requestId: data['requestId'], // Include requestId from Firestore
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'role': role,
      'sport': sport,
      'location': location,
      'imagePath': imagePath,
      'status': status,
      'connectedDate': Timestamp.fromDate(connectedDate),
      'requestId': requestId,
    };
  }
}