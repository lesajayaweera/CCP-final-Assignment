import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_ignite/model/ConnectionService.dart';
import 'package:sport_ignite/model/Sponsor.dart';
import 'package:sport_ignite/model/userCardData.dart';
import 'package:sport_ignite/pages/profileView.dart';

class AthletesScreen extends StatefulWidget {
  final String role;
  const AthletesScreen({super.key, required this.role});

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isLoading
            ? _buildLoadingState()
            : verifiedAthletes.isNotEmpty
                ? _buildAthletesView()
                : _buildEmptyState(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Finding Elite Athletes',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Searching through verified professional profiles',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
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
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.1),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'No Verified Athletes Yet',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Elite athletes are currently going through our verification process. Check back soon to discover amazing talent!',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey[600],
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.schedule,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    color: const Color(0xFF3B82F6),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAthletesView() {
    return CustomScrollView(
      slivers: [
        // Header section matching NetworkManagementScreen style
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.sports_tennis,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Elite Athletes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Verified talents ready to shine',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${verifiedAthletes.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Athletes grid section matching NetworkManagementScreen style
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
                            const Text(
                              'Verified Athletes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F2937),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Connect with these talented individuals',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: verifiedAthletes.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOutBack,
                        child: AthleteCard(
                          athlete: verifiedAthletes[index],
                          index: index,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AthleteCard extends StatefulWidget {
  final Athletes athlete;
  final int index;

  const AthleteCard({super.key, required this.athlete, required this.index});

  @override
  State<AthleteCard> createState() => _AthleteCardState();
}

class _AthleteCardState extends State<AthleteCard>
    with SingleTickerProviderStateMixin {
  String _connectionStatus = 'loading';
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
    _checkConnectionStatus();
  }

  @override
  void dispose() {
    _scaleController.dispose();
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
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    await ConnectionService.sendConnectionRequestUsingUID(
      context,
      widget.athlete.uid,
    );
    setState(() {
      _connectionStatus = 'pending';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Connected with ${widget.athlete.name}'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF10B981),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfileView(role: 'Athlete', uid: widget.athlete.uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _navigateToProfile,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? const Color(0xFF3B82F6) : Colors.grey.shade200,
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
                padding: const EdgeInsets.all(5.0),
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            widget.athlete.imagePath,
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
                          ),
                        ),
                      ),
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
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Enhanced sport badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sports_tennis,
                            size: 12,
                            color: const Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.athlete.sport,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Enhanced club info
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.athlete.club,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Enhanced Connect Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: _connectionStatus == 'pending'
                            ? LinearGradient(
                                colors: [Colors.grey[300]!, Colors.grey[400]!],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                              ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: _connectionStatus != 'pending'
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _connectionStatus == 'pending' ? null : _handleSendRequest,
                          borderRadius: BorderRadius.circular(25),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _connectionStatus == 'pending'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        color: Colors.grey[700],
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Pending',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
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
                                          fontSize: 12,
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

