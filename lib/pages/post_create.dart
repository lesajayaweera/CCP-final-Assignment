// import 'package:flutter/material.dart';

// class SharePostScreen extends StatefulWidget {
//   const SharePostScreen({super.key});

//   @override
//   State<SharePostScreen> createState() => _SharePostScreenState();
// }

// class _SharePostScreenState extends State<SharePostScreen> {
//   final TextEditingController _textController = TextEditingController();
//   String selectedAudience = 'Anyone';

//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Share post',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Handle post action
//               _handlePost();
//             },
//             child: const Text(
//               'Post',
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // User info section
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     // Profile picture
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: const DecorationImage(
//                           image: AssetImage('asset/image/profile.jpg'),
//                           fit: BoxFit.cover,
//                         ),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                     ),
//                     const SizedBox(width: 12),

//                     // Name and audience selector
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'KUMAR SANGAKKAR',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           GestureDetector(
//                             onTap: _showAudienceSelector,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey[400]!),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.public,
//                                     size: 16,
//                                     color: Colors.grey[600],
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     selectedAudience,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Icon(
//                                     Icons.arrow_drop_down,
//                                     size: 16,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // Text input
//                 TextField(
//                   controller: _textController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(
//                     hintText: 'What do you want to talk about?',
//                     hintStyle: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                     border: InputBorder.none,
//                   ),
//                   style: const TextStyle(fontSize: 16),
//                 ),

//                 const SizedBox(height: 16),

//                 // Divider
//                 Container(
//                   height: 4,
//                   width: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[800],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Action options
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               children: [
//                 ShareOption(
//                   icon: Icons.photo_library_outlined,
//                   title: 'Add a photo',
//                   onTap: () => _handleAction('photo'),
//                 ),
//                 ShareOption(
//                   icon: Icons.videocam_outlined,
//                   title: 'Take a video',
//                   onTap: () => _handleAction('video'),
//                 ),
//                 ShareOption(
//                   icon: Icons.celebration_outlined,
//                   title: 'Celebrate an occasion',
//                   onTap: () => _handleAction('celebrate'),
//                 ),
//                 ShareOption(
//                   icon: Icons.description_outlined,
//                   title: 'Add a document',
//                   onTap: () => _handleAction('document'),
//                 ),
//                 ShareOption(
//                   icon: Icons.work_outline,
//                   title: "Share that you're hiring",
//                   onTap: () => _handleAction('hiring'),
//                 ),
//                 ShareOption(
//                   icon: Icons.person_outline,
//                   title: 'Find an expert',
//                   onTap: () => _handleAction('expert'),
//                 ),
//                 ShareOption(
//                   icon: Icons.poll_outlined,
//                   title: 'Create a poll',
//                   onTap: () => _handleAction('poll'),
//                 ),
//               ],
//             ),
//           ),

//           // Bottom divider
//           Container(
//             margin: const EdgeInsets.only(bottom: 20),
//             height: 4,
//             width: 100,
//             decoration: BoxDecoration(
//               color: Colors.grey[800],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAudienceSelector() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.public),
//               title: const Text('Anyone'),
//               onTap: () {
//                 setState(() => selectedAudience = 'Anyone');
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.people),
//               title: const Text('Connections only'),
//               onTap: () {
//                 setState(() => selectedAudience = 'Connections only');
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleAction(String action) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('$action selected'),
//         duration: const Duration(seconds: 1),
//       ),
//     );
//   }

//   void _handlePost() {
//     if (_textController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please write something to post'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     // Handle post submission
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Post shared successfully!'),
//         duration: Duration(seconds: 2),
//       ),
//     );

//     Navigator.pop(context);
//   }
// }

// class ShareOption extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   const ShareOption({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 24,
//               color: Colors.grey[700],
//             ),
//             const SizedBox(width: 16),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Demo usage

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_ignite/model/User.dart';
import 'package:sport_ignite/model/postService.dart';

class SharePostScreen extends StatefulWidget {
  final String role;
  const SharePostScreen({super.key, required this.role});

  @override
  State<SharePostScreen> createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  final TextEditingController _textController = TextEditingController();
  String selectedAudience = 'Anyone';
  final PostService _postService = PostService();
  Map<String, dynamic>? userdata = {};
  bool _isPosting = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedMedia = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await Users().getUserDetails(context, widget.role);
    if (mounted) {
      setState(() {
        userdata = data;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.close, color: Colors.black87, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: _isPosting ? null : _handlePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: _isPosting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Main content card
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // User info section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Enhanced profile picture
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF1976D2),
                                    const Color(0xFF42A5F5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1976D2).withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 12,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                ),
                                child: FutureBuilder<String?>(
                                  future: Users().getUserProfileImage(widget.role),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: Colors.grey[50],
                                        ),
                                        child: const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation(Color(0xFF1976D2)),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasData && snapshot.data != null) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(snapshot.data!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: Colors.grey[100],
                                        ),
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.grey[500],
                                          size: 28,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Enhanced name and audience selector
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userdata?['name'] ?? 'User Name',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: _showAudienceSelector,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getAudienceIcon(),
                                            size: 18,
                                            color: const Color(0xFF1976D2),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            selectedAudience,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 18,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Enhanced text input
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _textController,
                            maxLines: 4,
                            minLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Share your thoughts...',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black45,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),

                        // Enhanced media preview
                        if (_selectedMedia.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedMedia.length,
                              itemBuilder: (context, index) {
                                final file = _selectedMedia[index];
                                final isVideo = file.path.endsWith('.mp4') || file.path.endsWith('.mov');
                                return Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              offset: const Offset(0, 2),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: isVideo
                                              ? Container(
                                                  color: Colors.black87,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.play_circle_filled,
                                                      color: Colors.white,
                                                      size: 48,
                                                    ),
                                                  ),
                                                )
                                              : Image.file(
                                                  File(file.path),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedMedia.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0xFFE0E0E0)),

                  // Enhanced action options
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add to your post',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView(
                              children: [
                                _buildEnhancedShareOption(
                                  icon: Icons.photo_camera_outlined,
                                  title: 'Add photos/videos',
                                  subtitle: 'Share images or videos',
                                  color: const Color(0xFF4CAF50),
                                  onTap: _pickMedia,
                                ),
                                const SizedBox(height: 12),
                                _buildEnhancedShareOption(
                                  icon: Icons.celebration_outlined,
                                  title: 'Celebrate an occasion',
                                  subtitle: 'Anniversaries, milestones & more',
                                  color: const Color(0xFFFF9800),
                                  onTap: () => _handleAction('celebrate'),
                                ),
                                const SizedBox(height: 12),
                                _buildEnhancedShareOption(
                                  icon: Icons.description_outlined,
                                  title: 'Add a document',
                                  subtitle: 'Share files with your network',
                                  color: const Color(0xFF9C27B0),
                                  onTap: () => _handleAction('document'),
                                ),
                                const SizedBox(height: 12),
                                _buildEnhancedShareOption(
                                  icon: Icons.work_outline,
                                  title: "Share that you're hiring",
                                  subtitle: 'Let others know about job openings',
                                  color: const Color(0xFF2196F3),
                                  onTap: () => _handleAction('hiring'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedShareOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
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
                        color: Colors.black87,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAudienceIcon() {
    switch (selectedAudience) {
      case 'Anyone':
        return Icons.public;
      case 'Connections only':
        return Icons.people;
      default:
        return Icons.public;
    }
  }

  void _showAudienceSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Who can see your post?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            // Options
            _buildAudienceOption(
              icon: Icons.public,
              title: 'Anyone',
              subtitle: 'Anyone on Sport Ignite',
              isSelected: selectedAudience == 'Anyone',
              onTap: () {
                setState(() => selectedAudience = 'Anyone');
                Navigator.pop(context);
              },
            ),
            _buildAudienceOption(
              icon: Icons.people,
              title: 'Connections only',
              subtitle: 'Only your connections',
              isSelected: selectedAudience == 'Connections only',
              onTap: () {
                setState(() => selectedAudience = 'Connections only');
                Navigator.pop(context);
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAudienceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFF1976D2).withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected 
                      ? const Color(0xFF1976D2)
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? const Color(0xFF1976D2)
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF1976D2),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action selected'),
        backgroundColor: const Color(0xFF1976D2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _pickMedia() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

      setState(() {
        _selectedMedia.addAll(images);
        if (video != null) _selectedMedia.add(video);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select media: $e'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _handlePost() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedMedia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something or add media'),
          backgroundColor: Color(0xFFFF5722),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      await _postService.createPost(
        text: text,
        audience: selectedAudience,
        mediaFiles: _selectedMedia,
        role: widget.role,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Post shared successfully!'),
              ],
            ),
            backgroundColor: Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to share post: $e')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }
}