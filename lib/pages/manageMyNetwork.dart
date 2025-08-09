// import 'package:flutter/material.dart';
// import 'package:sport_ignite/pages/manageInvititations.dart';
// // TODO :Need to do the Connection invitiation and Rejections 
// class NetworkManagementScreen extends StatefulWidget {
//   final String role;
//   const NetworkManagementScreen({Key? key, required this.role})
//     : super(key: key);

//   @override
//   State<NetworkManagementScreen> createState() =>
//       _NetworkManagementScreenState();
// }

// class _NetworkManagementScreenState extends State<NetworkManagementScreen> {
//   int selectedBottomNavIndex = 1; // My Network tab selected
//   String currentView = 'network'; // 'network' or 'invitations'

//   List<InvitationRequest> invitations = [
//     InvitationRequest(
//       id: '1',
//       uid: '1',
//       role: 'Athlete',
//       profileImage:
//           'https://images.unsplash.com/photo-1494790108755-2616b332c5cd?w=150&h=150&fit=crop&crop=face',
//       name: 'Sarah Johnson',
//       title: 'Senior Software Engineer at Google',
//       mutualConnections: 12,
//       timeAgo: '1 week ago',
//       message: 'I\'d love to connect with you!',
//     ),
//     InvitationRequest(
//       id: '1',
//       uid: '1',
//       role: 'Athlete',
//       profileImage:
//           'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
//       name: 'Michael Chen',
//       title: 'Product Manager at Microsoft',
//       mutualConnections: 5,
//       timeAgo: '3 days ago',
//       message: 'Let\'s connect and share insights about product development.',
//     ),
//     InvitationRequest(
//       id: '1',
//       uid: '1',
//       role: 'Athlete',
//       profileImage:
//           'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
//       name: 'Emily Rodriguez',
//       title: 'UX Designer at Adobe',
//       mutualConnections: 8,
//       timeAgo: '5 days ago',
//       message: null,
//     ),
//     InvitationRequest(
//       id: '1',
//       uid: '1',
//       role: 'Athlete',
//       profileImage:
//           'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
//       name: 'David Kumar',
//       title: 'Data Scientist at Netflix',
//       mutualConnections: 3,
//       timeAgo: '1 day ago',
//       message:
//           'Hi! I noticed we work in similar fields. Would love to connect.',
//     ),
//   ];


//   // Sample data
// List<SponsorCardDetails> sponsors = [
//   SponsorCardDetails(
//     name: 'Veronica Symo...',
//     title: 'Scout in Company',
//     company: 'Lomonosov Moscow State',
//     imagePath:
//         'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
//     companyLogo:
//         'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=50&h=50&fit=crop',
//   ),
//   SponsorCardDetails(
//     name: 'Alexey Makovs...',
//     title: 'Private Sponsor',
//     company: 'LIVERPOOL Moscow State',
//     imagePath:
//         'https://images.unsplash.com/photo-1566492031773-4f4e44671d66?w=150&h=150&fit=crop&crop=face',
//     companyLogo:
//         'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50&h=50&fit=crop',
//   ),
//   SponsorCardDetails(
//     name: 'Michael Riley',
//     title: 'Company Sponsor',
//     company: 'Tech Corp',
//     imagePath:
//         'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
//     companyLogo:
//         'https://images.unsplash.com/photo-1560472355-536de3962603?w=50&h=50&fit=crop',
//   ),
//   SponsorCardDetails(
//     name: 'Daniel Jenkins',
//     title: 'company sponsor',
//     company: 'Sports Academy',
//     imagePath:
//         'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&h=150&fit=crop&crop=face',
//     companyLogo:
//         'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=50&h=50&fit=crop',
//   ),
// ];


//   @override
//   Widget build(BuildContext context) {

//     return _buildNetworkView();
//   }

//   Widget _buildNetworkView() {
//     return Column(
//       children: [
//         // Top navigation options
//         Container(
//           color: Colors.white,
//           child: Column(
//             children: [
//               _buildNavOption(
//                 title: 'Manage my network',
//                 onTap: () => _navigateTo('manage_network'),
//               ),
//               const Divider(height: 1),
//               _buildNavOption(
//                 title: 'Invitation requests ',
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context)=> InvitationsScreen()),
//                   );
//                 },
//                 hasNotification: invitations.isNotEmpty,
//               ),

//               const Divider(height: 1),
//             ],
//           ),
//         ),

//         const SizedBox(height: 16),

//         // Sponsors section
//         Expanded(
//           child: Container(
//             color: Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     '${widget.role} You may know',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),

//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 12,
//                           childAspectRatio: 0.7,
//                         ),
//                     itemCount: sponsors.length,
//                     itemBuilder: (context, index) {
//                       return SponsorCard(
//                         sponsor: sponsors[index],
//                         onConnect: () => _connectWithSponsor(sponsors[index]),
//                         onDismiss: () => _dismissSponsor(index),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

  
//   Widget _buildNavOption({
//     required String title,
//     required VoidCallback onTap,
//     bool hasNotification = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             if (hasNotification)
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//                 margin: EdgeInsets.only(right: 8),
//               ),
//             Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateTo(String route) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Navigate to $route'),
//         duration: const Duration(seconds: 1),
//       ),
//     );
//   }

//   void _connectWithSponsor(SponsorCardDetails sponsor) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Connected with ${sponsor.name}'),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _dismissSponsor(int index) {
//     setState(() {
//       sponsors.removeAt(index);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Sponsor dismissed'),
//         duration: Duration(seconds: 1),
//       ),
//     );
//   }

  

//   void _showMessageOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.person_add),
//               title: const Text('New Connection'),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.message),
//               title: const Text('Send Message'),
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class SponsorCard extends StatelessWidget {
//   final SponsorCardDetails sponsor;
//   final VoidCallback onConnect;
//   final VoidCallback onDismiss;

//   const SponsorCard({
//     Key? key,
//     required this.sponsor,
//     required this.onConnect,
//     required this.onDismiss,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 // Profile Image
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: NetworkImage(sponsor.imagePath),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // Name
//                 Text(
//                   sponsor.name,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),

//                 // Title
//                 Text(
//                   sponsor.title,
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),

//                 // Company info
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 16,
//                       height: 16,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: NetworkImage(sponsor.companyLogo),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         sponsor.company,
//                         style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Connect Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     onPressed: onConnect,
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: Colors.blue[700]!),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                     ),
//                     child: Text(
//                       'Connect',
//                       style: TextStyle(
//                         color: Colors.blue[700],
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Dismiss button
//           Positioned(
//             top: 8,
//             right: 8,
//             child: GestureDetector(
//               onTap: onDismiss,
//               child: Container(
//                 width: 24,
//                 height: 24,
//                 decoration: const BoxDecoration(
//                   color: Colors.black54,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.close, color: Colors.white, size: 14),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class SponsorCardDetails {
//   final String name;
//   final String title;
//   final String company;
//   final String imagePath;
//   final String companyLogo;

//   SponsorCardDetails({
//     required this.name,
//     required this.title,
//     required this.company,
//     required this.imagePath,
//     required this.companyLogo,
//   });
// }

import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/manageInvititations.dart';

class NetworkManagementScreen extends StatefulWidget {
  final String role;
  const NetworkManagementScreen({Key? key, required this.role})
      : super(key: key);

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

  List<InvitationRequest> invitations = [
    InvitationRequest(
      id: '1',
      uid: '1',
      role: 'Athlete',
      profileImage:
          'https://images.unsplash.com/photo-1494790108755-2616b332c5cd?w=150&h=150&fit=crop&crop=face',
      name: 'Sarah Johnson',
      title: 'Senior Software Engineer at Google',
      mutualConnections: 12,
      timeAgo: '1 week ago',
      message: 'I\'d love to connect with you!',
    ),
    InvitationRequest(
      id: '2',
      uid: '2',
      role: 'Athlete',
      profileImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      name: 'Michael Chen',
      title: 'Product Manager at Microsoft',
      mutualConnections: 5,
      timeAgo: '3 days ago',
      message: 'Let\'s connect and share insights about product development.',
    ),
    InvitationRequest(
      id: '3',
      uid: '3',
      role: 'Athlete',
      profileImage:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      name: 'Emily Rodriguez',
      title: 'UX Designer at Adobe',
      mutualConnections: 8,
      timeAgo: '5 days ago',
      message: null,
    ),
    InvitationRequest(
      id: '4',
      uid: '4',
      role: 'Athlete',
      profileImage:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      name: 'David Kumar',
      title: 'Data Scientist at Netflix',
      mutualConnections: 3,
      timeAgo: '1 day ago',
      message:
          'Hi! I noticed we work in similar fields. Would love to connect.',
    ),
  ];

  List<SponsorCardDetails> sponsors = [
    SponsorCardDetails(
      name: 'Veronica Symo',
      title: 'Scout in Company',
      company: 'Lomonosov Moscow State',
      imagePath:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
      companyLogo:
          'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=50&h=50&fit=crop',
    ),
    SponsorCardDetails(
      name: 'Alexey Makovs',
      title: 'Private Sponsor',
      company: 'LIVERPOOL Moscow State',
      imagePath:
          'https://images.unsplash.com/photo-1566492031773-4f4e44671d66?w=150&h=150&fit=crop&crop=face',
      companyLogo:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=50&h=50&fit=crop',
    ),
    SponsorCardDetails(
      name: 'Michael Riley',
      title: 'Company Sponsor',
      company: 'Tech Corp',
      imagePath:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      companyLogo:
          'https://images.unsplash.com/photo-1560472355-536de3962603?w=50&h=50&fit=crop',
    ),
    SponsorCardDetails(
      name: 'Daniel Jenkins',
      title: 'Company Sponsor',
      company: 'Sports Academy',
      imagePath:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&h=150&fit=crop&crop=face',
      companyLogo:
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=50&h=50&fit=crop',
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildNetworkView(),
      ),
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
                _buildEnhancedNavOption(
                  icon: Icons.mail_outline_rounded,
                  title: 'Invitation requests',
                  subtitle: '${invitations.length} pending invitations',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvitationsScreen(),
                      ),
                    );
                  },
                  hasNotification: invitations.isNotEmpty,
                  notificationCount: invitations.length,
                  color: const Color(0xFF10B981),
                ),
              ],
            ),
          ),
        ),

        // Enhanced sponsors section
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
                              '${widget.role}s You May Know',
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
                    itemCount: sponsors.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOutBack,
                        child: EnhancedSponsorCard(
                          sponsor: sponsors[index],
                          onConnect: () => _connectWithSponsor(sponsors[index]),
                          onDismiss: () => _dismissSponsor(index),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to $route'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _connectWithSponsor(SponsorCardDetails sponsor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Connected with ${sponsor.name}'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF10B981),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _dismissSponsor(int index) {
    setState(() {
      sponsors.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.visibility_off, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Person dismissed'),
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

class EnhancedSponsorCard extends StatefulWidget {
  final SponsorCardDetails sponsor;
  final VoidCallback onConnect;
  final VoidCallback onDismiss;
  final int index;

  const EnhancedSponsorCard({
    Key? key,
    required this.sponsor,
    required this.onConnect,
    required this.onDismiss,
    required this.index,
  }) : super(key: key);

  @override
  State<EnhancedSponsorCard> createState() => _EnhancedSponsorCardState();
}

class _EnhancedSponsorCardState extends State<EnhancedSponsorCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
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
                        child: Image.network(
                          widget.sponsor.imagePath,
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

                  // Name
                  Text(
                    widget.sponsor.name,
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

                  // Title
                  Text(
                    widget.sponsor.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Enhanced company info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(widget.sponsor.companyLogo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.sponsor.company,
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
    );
  }
}

class SponsorCardDetails {
  final String name;
  final String title;
  final String company;
  final String imagePath;
  final String companyLogo;

  SponsorCardDetails({
    required this.name,
    required this.title,
    required this.company,
    required this.imagePath,
    required this.companyLogo,
  });
}