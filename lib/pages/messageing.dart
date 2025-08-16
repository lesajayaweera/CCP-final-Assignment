

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport_ignite/model/MessagingService.dart';
import 'package:sport_ignite/pages/chatScreen.dart';


class MessageData {
  final String name;
  final String message;
  final String time;
  final String? avatar;
  final bool hasUnreadIndicator;
  final bool isOnline;
  final MessageType type;
  final int unreadCount;
  final String chatId;
  final String otherUserId;

  MessageData({
    required this.name,
    required this.message,
    required this.time,
    this.avatar,
    this.hasUnreadIndicator = false,
    this.isOnline = false,
    this.type = MessageType.received,
    this.unreadCount = 0,
    required this.chatId,
    required this.otherUserId,
  });

  // Factory constructor to create MessageData from your Firestore data
  factory MessageData.fromFirestore(Map<String, dynamic> data) {
    final lastUpdated = data['lastUpdated'] as Timestamp?;
    final timeString = lastUpdated != null 
        ? _formatTimestamp(lastUpdated)
        : 'Unknown';

    return MessageData(
      name: data['otherUserName'] ?? 'Unknown User',
      message: data['lastMessage'] ?? 'No messages yet',
      time: timeString,
      avatar: data['otherUserProfilePic']?.isNotEmpty == true 
          ? data['otherUserProfilePic'] 
          : null,
      hasUnreadIndicator: false,
      isOnline: false, 
      type: MessageType.received, 
      unreadCount: 0,
      chatId: data['chatId'] ?? '',
      otherUserId: data['otherUserId'] ?? '',
    );
  }

  // Helper method to format timestamp
  static String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today - show time
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : hour;
      return '$displayHour:$minute $amPm';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day name
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[dateTime.weekday - 1];
    } else {
      // Older - show date
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');
      return '$month/$day';
    }
  }
}

enum MessageType { sent, received, inMail }

// Updated MessagingScreen to use MessagingService
class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';
  
  // Create instance of MessagingService
  final MessagingService _messagingService = MessagingService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
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
      backgroundColor: Color(0xFFF8FAFC),
      appBar: ModernAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            ModernSearchBar(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            Expanded(
              child: MessagesList(
                messagingService: _messagingService,
                searchQuery: _searchQuery,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF6366F1),
        elevation: 4,
        child: Icon(Icons.edit_rounded, color: Colors.white, size: 24),
      ),
    );
  }
}

// Updated MessagesList to use MessagingService
class MessagesList extends StatelessWidget {
  final MessagingService messagingService;
  final String searchQuery;

  const MessagesList({
    super.key, 
    required this.messagingService,
    this.searchQuery = ''
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: messagingService.getUserChatsWithDetails(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading conversations...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger rebuild to retry
                      (context as Element).markNeedsBuild();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6366F1),
                    ),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Handle empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start a new conversation to see it here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          // Convert Firestore data to MessageData objects
          final messageList = snapshot.data!
              .map((data) => MessageData.fromFirestore(data))
              .toList();

          // Apply search filter
          final filteredMessages = messageList.where((message) =>
              message.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              message.message.toLowerCase().contains(searchQuery.toLowerCase())).toList();

          // Handle empty search results
          if (filteredMessages.isEmpty && searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try searching with different keywords',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          // Display the list of conversations
          return ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemCount: filteredMessages.length,
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ModernMessageTile(
                  messageData: filteredMessages[index],
                  index: index,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _navigateToChat(context, filteredMessages[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToChat(BuildContext context, MessageData messageData) {
    // Navigate to ChatScreen using your existing navigation method
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: messageData.chatId,
          currentID: FirebaseAuth.instance.currentUser?.uid ?? '',
          targetID: messageData.otherUserId,
        ),
      ),
    );
  }
}

// Modern App Bar with gradient and blur effect
class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ModernAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Enhanced Search Bar with modern styling
class ModernSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const ModernSearchBar({
    super.key,
    this.hintText = 'Search conversations...',
    this.onChanged,
  });

  @override
  _ModernSearchBarState createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _isFocused 
                      ? Color(0xFF6366F1).withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: _isFocused ? 20 : 10,
                  offset: Offset(0, _isFocused ? 8 : 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: widget.onChanged,
              onTap: () {
                setState(() {
                  _isFocused = true;
                });
                _controller.forward();
              },
              onEditingComplete: () {
                setState(() {
                  _isFocused = false;
                });
                _controller.reverse();
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 12, right: 8),
                  child: Icon(
                    Icons.search_rounded,
                    color: _isFocused ? Color(0xFF6366F1) : Colors.grey[400],
                    size: 24,
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.tune_rounded,
                    color: Colors.grey[400],
                    size: 20,
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

// Modern Message Tile with enhanced styling and animations
class ModernMessageTile extends StatefulWidget {
  final MessageData messageData;
  final VoidCallback? onTap;
  final int index;

  const ModernMessageTile({
    super.key,
    required this.messageData,
    this.onTap,
    this.index = 0,
  });

  @override
  _ModernMessageTileState createState() => _ModernMessageTileState();
}

class _ModernMessageTileState extends State<ModernMessageTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        EnhancedUserAvatar(
                          name: widget.messageData.name,
                          avatar: widget.messageData.avatar,
                          isOnline: widget.messageData.isOnline,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.messageData.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xFF1F2937),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.messageData.time,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  if (widget.messageData.type == MessageType.inMail)
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'InMail',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      widget.messageData.message,
                                      style: TextStyle(
                                        color: widget.messageData.hasUnreadIndicator
                                            ? Color(0xFF374151)
                                            : Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: widget.messageData.hasUnreadIndicator
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        if (widget.messageData.hasUnreadIndicator)
                          ModernUnreadIndicator(count: widget.messageData.unreadCount),
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

// Enhanced User Avatar with better styling
class EnhancedUserAvatar extends StatelessWidget {
  final String name;
  final String? avatar;
  final bool isOnline;
  final double size;

  const EnhancedUserAvatar({
    super.key,
    required this.name,
    this.avatar,
    this.isOnline = false,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getGradientColors(name),
            ),
            boxShadow: [
              BoxShadow(
                color: _getGradientColors(name)[0].withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: avatar != null && avatar!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(size / 2),
                  child: Image.network(
                    avatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildInitials(),
                  ),
                )
              : _buildInitials(),
        ),
        if (isOnline)
          Positioned(
            right: 2,
            bottom: 2,
            child: ModernOnlineIndicator(),
          ),
      ],
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _getInitials(name),
        style: TextStyle(
          color: Colors.white,
          fontSize: size / 3,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    for (int i = 0; i < names.length && i < 2; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }
    return initials.isNotEmpty ? initials : '?';
  }

  List<Color> _getGradientColors(String name) {
    final gradients = [
      [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      [Color(0xFF06B6D4), Color(0xFF3B82F6)],
      [Color(0xFF10B981), Color(0xFF059669)],
      [Color(0xFFF59E0B), Color(0xFFEF4444)],
      [Color(0xFFEC4899), Color(0x00be185d)],
      [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    ];
    return gradients[name.hashCode.abs() % gradients.length];
  }
}

// Modern Online Indicator
class ModernOnlineIndicator extends StatelessWidget {
  final double size;

  const ModernOnlineIndicator({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFF10B981),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF10B981).withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

// Modern Unread Indicator with count
class ModernUnreadIndicator extends StatelessWidget {
  final int count;

  const ModernUnreadIndicator({super.key, this.count = 1});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: count > 9 ? 8 : 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}