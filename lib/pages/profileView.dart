// // ignore_for_file: unused_field

// import 'package:flutter/material.dart';
// import 'package:sport_ignite/model/Athlete.dart';
// import 'package:sport_ignite/model/ConnectionService.dart';
// import 'package:sport_ignite/model/User.dart';
// import 'package:sport_ignite/widget/common/appbar.dart';
// import 'package:sport_ignite/widget/profilePage/CertificateBanner.dart';

// import 'package:sport_ignite/widget/profilePage/StarItem.dart';

// class ProfileView extends StatefulWidget {
//   final String role;
//   final String? uid;

//   ProfileView({super.key, required this.role, required this.uid});

//   @override
//   _ProfileViewState createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<ProfileView> {
//   Map<String, dynamic>? userData;

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   // void loadUserData() async {
//   //   if (widget.uid != null) {
//   //     var data = await Users().getUserDetailsByUIDAndRole(
//   //       context,
//   //       widget.uid!,
//   //       widget.role,
//   //     );
//   //     setState(() {
//   //       userData = data;
//   //     });
//   //   } else {
//   //     var data = await Users().getUserDetails(context, widget.role);
//   //     setState(() {
//   //       userData = data;
//   //     });
//   //   }
//   // }

//   void loadUserData() async {
//     if (widget.uid != null) {
//       var data = await Users().getUserDetailsByUIDAndRole(
//         context,
//         widget.uid!,
//         widget.role,
//       );
//       setState(() {
//         userData = data;
//       });

//       if (data?['sport'] != null && data?['email'] != null) {
//         await Athlete.loadUserStats(data!['sport'], data['email']);
//       }
//     } else {
//       var data = await Users().getUserDetails(context, widget.role);
//       setState(() {
//         userData = data;
//       });

//       if (data?['sport'] != null && data?['email'] != null) {
//         await Athlete.loadUserStats(data!['sport'], data['email']);
//       }
//     }
//   }

//   Future<List<Map<String, dynamic>>> loadCertificates() async {
//     if (widget.uid != null) {
//       try {
//         return await Athlete.getApprovedCertificatesBYuid(widget.uid!);
//       } catch (e) {
//         print('Error loading certificates: $e');
//       }
//     }
//     return [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: LinkedInAppBar(page: true, role: widget.role),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Background and profile image section
//               Container(
//                 height: 190,
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 50),
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey,
//                         image:
//                             (userData?['background'] != null &&
//                                 userData!['background'].toString().isNotEmpty)
//                             ? DecorationImage(
//                                 image: NetworkImage(userData!['background']),
//                                 fit: BoxFit.cover,
//                               )
//                             : null,
//                       ),
//                       child:
//                           (userData?['background'] == null ||
//                               userData!['background'].toString().isEmpty)
//                           ? const Center(
//                               child: Icon(
//                                 Icons.person,
//                                 size: 60,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : null,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: SizedBox(
//                           width: 150,
//                           height: 150,
//                           child: Stack(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade300,
//                                   shape: BoxShape.circle,
//                                   image:
//                                       (userData?['profile'] != null &&
//                                           userData!['profile']
//                                               .toString()
//                                               .isNotEmpty)
//                                       ? DecorationImage(
//                                           fit: BoxFit.cover,
//                                           image: NetworkImage(
//                                             userData!['profile'],
//                                           ),
//                                         )
//                                       : null,
//                                 ),
//                                 child:
//                                     (userData?['profile'] == null ||
//                                         userData!['profile'].toString().isEmpty)
//                                     ? const Icon(
//                                         Icons.person,
//                                         size: 50,
//                                         color: Colors.white70,
//                                       )
//                                     : null,
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: CircleAvatar(
//                                   radius: 20,
//                                   backgroundColor: Theme.of(
//                                     context,
//                                   ).scaffoldBackgroundColor,
//                                   child: Container(
//                                     margin: const EdgeInsets.all(8.0),
//                                     decoration: const BoxDecoration(
//                                       color: Colors.green,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Name, city, and other info
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       userData?['name'] ?? "Guest",
//                       style: Theme.of(context).textTheme.headlineMedium
//                           ?.copyWith(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 16),
//                     widget.role == 'Sponsor'
//                         ? Text("${userData?['company']} - ${userData?['role']}")
//                         : Text(userData?['sport'] ?? ''),
//                     Text(
//                       "${userData?['city'] ?? 'city'}\n${userData?['province'] ?? 'province'}, Sri Lanka",
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                     const SizedBox(height: 10),

//                     Container(
//                       width: double.infinity,
//                       child: Row(
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               ConnectionService.sendConnectionRequestUsingUID(
//                                 context,
//                                 widget.uid!,
//                               );
//                             },
//                             child: const Text("Connect"),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Stats
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 20,
//                         horizontal: 16,
//                       ),
//                       child: widget.role != 'Sponsor'
//                           ? if (widget.userData?['sport'] == 'Cricket')
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: const [
//                                 StatItem(
//                                   value: '2,279,545',
//                                   label: 'Total Runs',
//                                 ),
//                                 VerticalDivider(),
//                                 StatItem(
//                                   value: '279,545',
//                                   label: 'Total Matches',
//                                 ),
//                                 VerticalDivider(),
//                                 StatItem(value: '279,545', label: '100 s'),
//                               ],
//                             )
//                           : Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: const [
//                                 StatItem(
//                                   value: 'Rs.0.00',
//                                   label: 'Total Sponsored',
//                                 ),
//                                 VerticalDivider(),
//                                 StatItem(value: '0', label: 'Total Athletes'),
//                               ],
//                             ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Certificates
//                     if (widget.role != 'Sponsor')
//                       FutureBuilder<List<Map<String, dynamic>>>(
//                         future: loadCertificates(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           } else if (snapshot.hasError) {
//                             return Text('Error: ${snapshot.error}');
//                           } else if (!snapshot.hasData ||
//                               snapshot.data!.isEmpty) {
//                             return const Text('No certificates found.');
//                           }

//                           return CertificateBanner(
//                             certificates: snapshot.data!,
//                           );
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Stat display widget

// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:sport_ignite/model/Athlete.dart';
import 'package:sport_ignite/model/ConnectionService.dart';
import 'package:sport_ignite/model/MessagingService.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/widget/common/appbar.dart';
import 'package:sport_ignite/widget/profilePage/CertificateBanner.dart';

class ProfileView extends StatefulWidget {
  final String role;
  final String? uid;

  ProfileView({super.key, required this.role, required this.uid});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? userStats;
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    loadUserData();
    _animationController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void loadUserData() async {
    if (widget.uid != null) {
      var data = await Users().getUserDetailsByUIDAndRole(
        context,
        widget.uid!,
        widget.role,
      );
      setState(() {
        userData = data;
      });

      if (data?['sport'] != null && data?['email'] != null) {
        var stats = await Athlete.loadUserStats(data!['sport'], data['email']);
        setState(() {
          userStats = stats;
        });
      }
    } else {
      var data = await Users().getUserDetails(context, widget.role);
      setState(() {
        userData = data;
      });

      if (data?['sport'] != null && data?['email'] != null) {
        var stats = await Athlete.loadUserStats(data!['sport'], data['email']);
        setState(() {
          userStats = stats;
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> loadCertificates() async {
    if (widget.uid != null) {
      try {
        return await Athlete.getApprovedCertificatesBYuid(widget.uid!);
      } catch (e) {
        print('Error loading certificates: $e');
      }
    }
    return [];
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade400,
            Colors.purple.shade300,
            Colors.pink.shade200,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background with gradient overlay
          Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: Stack(
              fit: StackFit.expand,
              children: [
                userData?['background'] != null &&
                        userData!['background'].toString().isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(userData!['background']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : _buildGradientBackground(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Profile Picture with enhanced styling
          Positioned(
            bottom: 20,
            left: 20,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    image:
                        userData?['profile'] != null &&
                            userData!['profile'].toString().isNotEmpty
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userData!['profile']),
                          )
                        : null,
                  ),
                  child:
                      userData?['profile'] == null ||
                          userData!['profile'].toString().isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white70,
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Online Status Indicator
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData?['name'] ?? "Guest",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.role == 'Sponsor'
                    ? Colors.orange.shade100
                    : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.role == 'Sponsor'
                    ? "${userData?['company']} - ${userData?['role']}"
                    : userData?['sport'] ?? '',
                style: TextStyle(
                  color: widget.role == 'Sponsor'
                      ? Colors.orange.shade700
                      : Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey.shade600, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "${userData?['city'] ?? 'City'}, ${userData?['province'] ?? 'Province'}, Sri Lanka",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildConnectButton(),
            const SizedBox(height: 10),
            _buildMesageButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isConnecting
            ? null
            : () async {
                setState(() {
                  _isConnecting = true;
                });

                try {
                  await ConnectionService.sendConnectionRequestUsingUID(
                    context,
                    widget.uid!,
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      _isConnecting = false;
                    });
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isConnecting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person_add),
                  SizedBox(width: 8),
                  Text(
                    "Connect",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMesageButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            MessagingService.startNewChat(
              context,
              widget.uid!,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.message_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "Message",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.role == 'Sponsor'
                  ? 'Sponsorship Stats'
                  : 'Performance Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            buildStatsWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildStatsWidget() {
    if (widget.role == 'Sponsor') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            'Rs.0.00',
            'Total Sponsored',
            Icons.monetization_on,
            Colors.green,
          ),
          _buildVerticalDivider(),
          _buildStatItem('0', 'Total Athletes', Icons.group, Colors.blue),
        ],
      );
    }

    if (userData == null || userStats == null) {
      return Center(
        child: Text(
          'No stats available about this user',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    String sport = userData!['sport'] ?? '';
    List<Widget> statsWidgets = [];

    if (sport == 'Cricket') {
      statsWidgets = [
        _buildStatItem(
          userStats?['Runs'].toString() ?? '-',
          'Total Runs',
          Icons.sports_cricket,
          Colors.orange,
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          userStats?['MatchesPlayed'].toString() ?? '-',
          'Matches',
          Icons.sports,
          Colors.blue,
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          userStats?['Hundreds'].toString() ?? '-',
          '100s',
          Icons.star,
          Colors.amber,
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          userStats?['Fifties'].toString() ?? '-',
          '100s',
          Icons.star,
          Colors.amber,
        ),
      ];
    } else if (sport == 'Basketball') {
      statsWidgets = [
        _buildStatItem(
          userStats?['Points'].toString() ?? '-',
          'Points',
          Icons.sports_basketball,
          Colors.orange,
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          userStats?['Assists'].toString() ?? '-',
          'Assists',
          Icons.handshake,
          Colors.blue,
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          userStats?['Rebounds'].toString() ?? '-',
          'Rebounds',
          Icons.replay,
          Colors.green,
        ),
      ];
    } else if (sport == 'Football') {
      statsWidgets = [
        _buildStatItem(
          userStats?['MinutesPlayed'].toString() ?? '-',
          'Minutes Played',
          Icons.sports_soccer,
          Colors.orange,
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          userStats?['PassAccuracy'].toString() ?? '-',
          'Pass Accuracy',
          Icons.handshake,
          Colors.blue,
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          userStats?['Goals'].toString() ?? '-',
          'Goals',
          Icons.sports,
          Colors.green,
        ),
      ];
    } else {
      return Center(
        child: Text(
          'No stats available for this sport',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: statsWidgets,
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildCertificatesSection() {
    if (widget.role == 'Sponsor') return const SizedBox.shrink();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: loadCertificates(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade400),
                          const SizedBox(width: 8),
                          Text(
                            'Error loading certificates',
                            style: TextStyle(color: Colors.red.shade600),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey.shade400),
                          const SizedBox(width: 8),
                          Text(
                            'No certificates found',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  }
                  return CertificateBanner(certificates: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LinkedInAppBar(page: true, role: widget.role),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 20),
              _buildUserInfo(),
              _buildStatsCard(),
              _buildCertificatesSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
