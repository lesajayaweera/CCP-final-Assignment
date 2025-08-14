import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/profileView.dart';
import 'package:sport_ignite/model/ConnectionService.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (myUid.isEmpty) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connection Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Manage your pending invitations',
                  style: TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('connection_requests')
            .where('receiverUID', isEqualTo: myUid)
            .where('status', isEqualTo: 'pending')
            //.orderBy('timestamp', descending: true) // comment out for test
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildLoadingState();
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) return _buildEmptyState();

          return FutureBuilder<List<InvitationRequest>>(
            future: _enrichInvitations(requests),
            builder: (context, enrichedSnapshot) {
              if (!enrichedSnapshot.hasData) {
                return _buildLoadingState();
              }

              final invitations = enrichedSnapshot.data!;
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final invitation = invitations[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 200 + (index * 50)),
                            curve: Curves.easeOutCubic,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        ProfileView(
                                          role: invitation.role,
                                          uid: invitation.uid,
                                        ),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: animation.drive(
                                          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                                        ),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: InvitationCard(invitation: invitation),
                            ),
                          );
                        },
                        childCount: invitations.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Loading invitations...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667EEA).withOpacity(0.1),
                  const Color(0xFF764BA2).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.people_outline_rounded,
              size: 60,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'No Pending Invitations',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: const Text(
              'When people send you connection requests, they\'ll appear here for you to review and respond.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Text(
              '✨ Start connecting with athletes and sponsors!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<InvitationRequest>> _enrichInvitations(
    List<QueryDocumentSnapshot> docs,
  ) async {
    List<Future<InvitationRequest>> futures = docs.map((doc) async {
      final data = doc.data() as Map<String, dynamic>;
      final senderUID = data['senderUID'];
      final timestamp = data['timestamp'] as Timestamp;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('sponsor')
          .doc(senderUID)
          .get();

      String name = "";
      String title = "";
      String profileImage = "";
      String role = "";

      if (userDoc.exists) {
        final user = userDoc.data() as Map<String, dynamic>;
        name = user['name'];
        title = '${user['sportIntrested']} Sponsor';
        profileImage = user['profile'];
        role = "sponsor";
      } else {
        userDoc = await FirebaseFirestore.instance
            .collection('athlete')
            .doc(senderUID)
            .get();

        if (userDoc.exists) {
          final user = userDoc.data() as Map<String, dynamic>;
          name = user['name'];
          title = '${user['sport']} Athlete';
          profileImage = user['profile'];
          role = "athlete";
        }
      }

      return InvitationRequest(
        id: doc.id,
        uid: senderUID,
        role: role,
        profileImage: profileImage,
        name: name,
        title: title,
        mutualConnections: 0,
        timeAgo: _formatTimestamp(timestamp),
        message: null,
      );
    }).toList();

    return Future.wait(futures);
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp.toDate());

    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

class InvitationRequest {
  final String id;
  final String profileImage;
  final String uid;
  final String role;
  final String name;
  final String title;
  final int mutualConnections;
  final String timeAgo;
  final String? message;

  InvitationRequest({
    required this.id,
    required this.uid,
    required this.role,
    required this.profileImage,
    required this.name,
    required this.title,
    required this.mutualConnections,
    required this.timeAgo,
    this.message,
  });
}

class InvitationCard extends StatefulWidget {
  final InvitationRequest invitation;

  const InvitationCard({
    super.key,
    required this.invitation,
  });

  @override
  State<InvitationCard> createState() => _InvitationCardState();
}

class _InvitationCardState extends State<InvitationCard>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _ignoreController;
  late AnimationController _acceptController;
  
  late Animation<double> _cardScale;
  late Animation<double> _ignoreScale;
  late Animation<double> _acceptScale;
  late Animation<Color?> _ignoreColor;
  late Animation<Color?> _acceptColor;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    
    // Card animation controller
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Button animation controllers
    _ignoreController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _acceptController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Card scale animation
    _cardScale = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    ));

    // Button scale animations
    _ignoreScale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _ignoreController,
      curve: Curves.easeInOut,
    ));

    _acceptScale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _acceptController,
      curve: Curves.easeInOut,
    ));

    // Button color animations
    _ignoreColor = ColorTween(
      begin: const Color(0xFFE2E8F0),
      end: const Color(0xFFCBD5E1),
    ).animate(_ignoreController);

    _acceptColor = ColorTween(
      begin: const Color(0xFF667EEA),
      end: const Color(0xFF5A67D8),
    ).animate(_acceptController);
  }

  @override
  void dispose() {
    _cardController.dispose();
    _ignoreController.dispose();
    _acceptController.dispose();
    super.dispose();
  }

  void _onIgnorePressed() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    await _ignoreController.forward();
    await _ignoreController.reverse();
    
    // Add haptic feedback
    // HapticFeedback.lightImpact();
    
    await ConnectionService.rejectConnectionRequest(context, widget.invitation.uid);
    
    setState(() => _isProcessing = false);
  }

  void _onAcceptPressed() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    await _acceptController.forward();
    await _acceptController.reverse();
    
    // Add haptic feedback
    // HapticFeedback.lightImpact();
    
    await ConnectionService.acceptConnectionRequest(
      widget.invitation.id,
      widget.invitation.uid,
    );
    
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cardController,
      builder: (context, child) {
        return Transform.scale(
          scale: _cardScale.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTapDown: (_) => _cardController.forward(),
                  onTapUp: (_) => _cardController.reverse(),
                  onTapCancel: () => _cardController.reverse(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF667EEA).withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: CircleAvatar(
                                      radius: 32,
                                      backgroundImage: NetworkImage(widget.invitation.profileImage),
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: widget.invitation.role == 'athlete' 
                                          ? const Color(0xFF10B981) 
                                          : const Color(0xFF8B5CF6),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Icon(
                                      widget.invitation.role == 'athlete' 
                                          ? Icons.sports_soccer 
                                          : Icons.business_center,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.invitation.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1E293B),
                                            letterSpacing: -0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          widget.invitation.timeAgo,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: widget.invitation.role == 'athlete'
                                            ? [const Color(0xFF10B981).withOpacity(0.1), const Color(0xFF059669).withOpacity(0.1)]
                                            : [const Color(0xFF8B5CF6).withOpacity(0.1), const Color(0xFF7C3AED).withOpacity(0.1)],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      widget.invitation.title,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: widget.invitation.role == 'athlete' 
                                            ? const Color(0xFF059669) 
                                            : const Color(0xFF7C3AED),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.people_outline,
                                          size: 14,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${widget.invitation.mutualConnections} mutual connections',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (widget.invitation.message != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFFF8FAFC),
                                  const Color(0xFFF1F5F9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(
                              widget.invitation.message!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF475569),
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _ignoreController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _ignoreScale.value,
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: _ignoreColor.value,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: const Color(0xFFCBD5E1),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(24),
                                          onTap: _isProcessing ? null : _onIgnorePressed,
                                          child: Center(
                                            child: _isProcessing
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF64748B)),
                                                    ),
                                                  )
                                                : const Text(
                                                    'Decline',
                                                    style: TextStyle(
                                                      color: Color(0xFF64748B),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _acceptController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _acceptScale.value,
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [_acceptColor.value!, const Color(0xFF764BA2)],
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF667EEA).withOpacity(0.4),
                                            blurRadius: 15,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(24),
                                          onTap: _isProcessing ? null : _onAcceptPressed,
                                          child: Center(
                                            child: _isProcessing
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  )
                                                : const Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}