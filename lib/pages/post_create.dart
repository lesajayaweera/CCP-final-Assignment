import 'package:flutter/material.dart';

class SharePostScreen extends StatefulWidget {
  const SharePostScreen({super.key});

  @override
  State<SharePostScreen> createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  final TextEditingController _textController = TextEditingController();
  String selectedAudience = 'Anyone';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton( 
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Share post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle post action
              _handlePost();
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // User info section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Profile picture
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('asset/image/profile.jpg'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Name and audience selector
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'KUMAR SANGAKKAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: _showAudienceSelector,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.public,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    selectedAudience,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 16,
                                    color: Colors.grey[600],
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
                const SizedBox(height: 16),
                
                // Text input
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'What do you want to talk about?',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                
                const SizedBox(height: 16),
                
                // Divider
                Container(
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          
          // Action options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ShareOption(
                  icon: Icons.photo_library_outlined,
                  title: 'Add a photo',
                  onTap: () => _handleAction('photo'),
                ),
                ShareOption(
                  icon: Icons.videocam_outlined,
                  title: 'Take a video',
                  onTap: () => _handleAction('video'),
                ),
                ShareOption(
                  icon: Icons.celebration_outlined,
                  title: 'Celebrate an occasion',
                  onTap: () => _handleAction('celebrate'),
                ),
                ShareOption(
                  icon: Icons.description_outlined,
                  title: 'Add a document',
                  onTap: () => _handleAction('document'),
                ),
                ShareOption(
                  icon: Icons.work_outline,
                  title: "Share that you're hiring",
                  onTap: () => _handleAction('hiring'),
                ),
                ShareOption(
                  icon: Icons.person_outline,
                  title: 'Find an expert',
                  onTap: () => _handleAction('expert'),
                ),
                ShareOption(
                  icon: Icons.poll_outlined,
                  title: 'Create a poll',
                  onTap: () => _handleAction('poll'),
                ),
              ],
            ),
          ),
          
          // Bottom divider
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  void _showAudienceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Anyone'),
              onTap: () {
                setState(() => selectedAudience = 'Anyone');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Connections only'),
              onTap: () {
                setState(() => selectedAudience = 'Connections only');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action selected'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handlePost() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something to post'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Handle post submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post shared successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
    
    Navigator.pop(context);
  }
}

class ShareOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ShareOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Demo usage
