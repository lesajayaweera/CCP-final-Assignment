import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/model/ConnectionService.dart';
import 'package:sport_ignite/model/Sponsor.dart';
import 'package:sport_ignite/model/userCardData.dart';
import 'package:sport_ignite/pages/profileView.dart';

class AthletesScreen extends StatefulWidget {
  final String role;
  const AthletesScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen>
    with TickerProviderStateMixin {
  List<Athletes> verifiedAthletes = [];
  List<String> verifiedUids = [];
  bool isLoading = true;
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
    fetchVerifiedAthletes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void fetchVerifiedAthletes() async {
    setState(() {
      isLoading = true;
    });

    final uids = await Sponsor.getUidsWithApprovedCertificates();

    if (!mounted) return;

    final List<Athletes> fetchedAthletes = [];

    for (final uid in uids) {
      final doc = await FirebaseFirestore.instance
          .collection('athlete')
          .doc(uid)
          .get();
      if (doc.exists) {
        fetchedAthletes.add(Athletes.fromFirestore(doc));
      }
    }

    setState(() {
      verifiedUids = uids;
      verifiedAthletes = fetchedAthletes;
      isLoading = false;
    });

    _animationController.forward();

    print('Verified UIDs: $uids');
    print('Fetched Athletes Count: ${fetchedAthletes.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4C63D2),
            Color(0xFF21D4FD),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Elite Athletes',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Verified talents ready to shine',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${verifiedAthletes.length} Verified Athletes',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: isLoading
                  ? _buildLoadingState()
                  : verifiedAthletes.isNotEmpty
                      ? _buildAthletesGrid()
                      : _buildEmptyState(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C63D2)),
              strokeWidth: 4,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Finding elite athletes...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Searching through verified profiles',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
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
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4C63D2).withOpacity(0.1),
                  const Color(0xFF21D4FD).withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 70,
              color: Color(0xFF4C63D2),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'No verified athletes yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Elite athletes are currently being verified. Check back soon for amazing talent!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAthletesGrid() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: verifiedAthletes.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final animationDelay = index * 0.1;
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      animationDelay,
                      1.0,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                );

                return SlideTransition(
                  position: slideAnimation,
                  child: AthleteCard(athlete: verifiedAthletes[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AthleteCard extends StatefulWidget {
  final Athletes athlete;

  const AthleteCard({Key? key, required this.athlete}) : super(key: key);

  @override
  State<AthleteCard> createState() => _AthleteCardState();
}

class _AthleteCardState extends State<AthleteCard>
    with SingleTickerProviderStateMixin {
  String _connectionStatus = 'loading';
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _checkConnectionStatus();
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectionStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final hasSent = await ConnectionService.hasSentRequest(
      currentUser.uid,
      widget.athlete.uid,
    );

    if (mounted) {
      setState(() {
        _connectionStatus = hasSent ? 'pending' : 'none';
      });
    }
  }

  Future<void> _handleSendRequest() async {
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    await ConnectionService.sendConnectionRequestUsingUID(
      context,
      widget.athlete.uid,
    );
    setState(() {
      _connectionStatus = 'pending';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileView(role: 'Athlete', uid: widget.athlete.uid),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 0.98 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4C63D2).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Profile Image with verification badge
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF4C63D2).withOpacity(0.8),
                                const Color(0xFF21D4FD).withOpacity(0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4C63D2).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(widget.athlete.imagePath),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Verification badge
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Name with verified badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            widget.athlete.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF10B981),
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Sport with enhanced styling
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4C63D2).withOpacity(0.1),
                            const Color(0xFF21D4FD).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4C63D2).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sports_soccer,
                            size: 12,
                            color: Color(0xFF4C63D2),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.athlete.sport,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4C63D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Club with enhanced styling
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.athlete.club,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Enhanced Connect Button
                    ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _connectionStatus == 'pending'
                              ? null
                              : _handleSendRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _connectionStatus == 'pending'
                                ? Colors.grey[300]
                                : null,
                            foregroundColor: _connectionStatus == 'pending'
                                ? Colors.grey[600]
                                : Colors.white,
                            elevation: _connectionStatus == 'pending' ? 0 : 4,
                            shadowColor: const Color(0xFF4C63D2).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).copyWith(
                            backgroundColor: _connectionStatus == 'pending'
                                ? WidgetStateProperty.all(Colors.grey[300])
                                : WidgetStateProperty.all(null),
                            overlayColor: WidgetStateProperty.resolveWith((states) {
                              if (_connectionStatus != 'pending') {
                                return const Color(0xFF4C63D2);
                              }
                              return null;
                            }),
                          ),
                          child: _connectionStatus == 'pending'
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Pending',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4C63D2),
                                        Color(0xFF21D4FD),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_add,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Connect',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
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

              // Enhanced close button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    // Optional remove from list
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black54,
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


////
///
///
///
///
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sport_ignite/model/ConnectionService.dart';
// import 'package:sport_ignite/model/Sponsor.dart';
// import 'package:sport_ignite/model/userCardData.dart';
// import 'package:sport_ignite/pages/profileView.dart';

// class AthletesScreen extends StatefulWidget {
//   final String role;
//   // final bool fromProfile;
//   const AthletesScreen({Key? key, required this.role}) : super(key: key);

//   @override
//   State<AthletesScreen> createState() => _AthletesScreenState();
// }

// class _AthletesScreenState extends State<AthletesScreen> {
//   List<Athletes> verifiedAthletes = [];
//   List<String> verifiedUids = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchVerifiedAthletes();
//   }

//   void fetchVerifiedAthletes() async {
//     final uids = await Sponsor.getUidsWithApprovedCertificates();

//     if (!mounted) return; // to avoid setState after widget disposed

//     final List<Athletes> fetchedAthletes = [];

//     for (final uid in uids) {
//       final doc = await FirebaseFirestore.instance
//           .collection('athlete')
//           .doc(uid)
//           .get();
//       if (doc.exists) {
//         fetchedAthletes.add(Athletes.fromFirestore(doc));
//       }
//     }

//     setState(() {
//       verifiedUids = uids;
//       verifiedAthletes = fetchedAthletes;
//     });

//     print('Verified UIDs: $uids');
//     print('Fetched Athletes Count: ${fetchedAthletes.length}');
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (verifiedAthletes.isNotEmpty)
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text('Athletes you May Know'),
//           ),

//         Expanded(
//           child: verifiedAthletes.isNotEmpty
//               ? Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                           childAspectRatio: 0.7,
//                         ),
//                     itemCount: verifiedAthletes.length,
//                     itemBuilder: (context, index) {
//                       return AthleteCard(athlete: verifiedAthletes[index]);
//                     },
//                   ),
//                 )
//               : const Center(child: Text('No Verified Athletes at the moment')),
//         ),
//       ],
//     );
//   }
// }

// class AthleteCard extends StatefulWidget {
//   final Athletes athlete;

//   const AthleteCard({Key? key, required this.athlete}) : super(key: key);

//   @override
//   State<AthleteCard> createState() => _AthleteCardState();
// }

// class _AthleteCardState extends State<AthleteCard> {
//   String _connectionStatus = 'loading'; // 'loading', 'none', 'pending'

//   @override
//   void initState() {
//     super.initState();
//     _checkConnectionStatus();
//   }

//   Future<void> _checkConnectionStatus() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) return;

//     final hasSent = await ConnectionService.hasSentRequest(
//       currentUser.uid,
//       widget.athlete.uid,
//     );

//     if (mounted) {
//       setState(() {
//         _connectionStatus = hasSent ? 'pending' : 'none';
//       });
//     }
//   }

//   Future<void> _handleSendRequest() async {
//     await ConnectionService.sendConnectionRequestUsingUID(
//       context,
//       widget.athlete.uid,
//     );
//     setState(() {
//       _connectionStatus = 'pending';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 ProfileView(role: 'Athlete', uid: widget.athlete.uid),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Profile Image
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: NetworkImage(widget.athlete.imagePath),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Name
//                   Text(
//                     widget.athlete.name,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),

//                   // Sport
//                   Text(
//                     widget.athlete.sport,
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 6),

//                   // Club
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           widget.athlete.club,
//                           style:
//                               TextStyle(fontSize: 11, color: Colors.grey[600]),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),

//                   // Connect Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _connectionStatus == 'pending'
//                           ? null
//                           : _handleSendRequest,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _connectionStatus == 'pending'
//                             ? Colors.grey
//                             : Colors.white,
//                         foregroundColor: Colors.blue[700],
//                         side: BorderSide(color: Colors.blue[700]!),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                       ),
//                       child: Text(
//                         _connectionStatus == 'pending' ? 'Pending' : 'Connect',
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Close button (optional functionality)
//             Positioned(
//               top: 8,
//               right: 8,
//               child: GestureDetector(
//                 onTap: () {
//                   // Optional remove from list
//                 },
//                 child: Container(
//                   width: 22,
//                   height: 22,
//                   decoration: const BoxDecoration(
//                     color: Colors.black54,
//                     shape: BoxShape.circle,
//                   ),
//                   child:
//                       const Icon(Icons.close, color: Colors.white, size: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // Sample data

