// import 'package:flutter/material.dart';

// // Data model for messages
// class MessageData {
//   final String name;
//   final String message;
//   final String time;
//   final String? avatar;
//   final bool hasUnreadIndicator;
//   final bool isOnline;
//   final MessageType type;

//   MessageData({
//     required this.name,
//     required this.message,
//     required this.time,
//     this.avatar,
//     this.hasUnreadIndicator = false,
//     this.isOnline = false,
//     this.type = MessageType.received,
//   });
// }

// enum MessageType { sent, received, inMail }

// // Main messaging screen
// class MessagingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: MessagingAppBar(),
//       body: Column(
//         children: [
//           SearchBar(),
//           Expanded(
//             child: MessagesList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Reusable App Bar Component
// class MessagingAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back, color: Colors.black),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text(
//         'Messaging',
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.more_vert, color: Colors.black),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: Icon(Icons.edit, color: Colors.black),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

// // Reusable Search Bar Component
// class SearchBar extends StatelessWidget {
//   final String hintText;
//   final ValueChanged<String>? onChanged;

//   const SearchBar({
//     Key? key,
//     this.hintText = 'Search messages',
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextField(
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           icon: Icon(Icons.search, color: Colors.grey[600]),
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey[600]),
//           border: InputBorder.none,
//           suffixIcon: Icon(Icons.tune, color: Colors.grey[600]),
//         ),
//       ),
//     );
//   }
// }

// // Main Messages List Component
// class MessagesList extends StatelessWidget {
//   final List<MessageData>? messages;

//   const MessagesList({Key? key, this.messages}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final messageList = messages ?? _getSampleMessages();
    
//     return ListView.builder(
//       itemCount: messageList.length,
//       itemBuilder: (context, index) {
//         return MessageTile(
//           messageData: messageList[index],
//           onTap: () {
//             // Handle message tap
//             print('Tapped on ${messageList[index].name}');
//           },
//         );
//       },
//     );
//   }

//   // Sample data - replace with your actual data
//   List<MessageData> _getSampleMessages() {
//     return [
//       MessageData(
//         name: 'Stuart Arnold',
//         message: 'Of course send your mail',
//         time: '10:07 AM',
//         hasUnreadIndicator: true,
//       ),
//       MessageData(
//         name: 'Thomas Simmons',
//         message: 'You: OK',
//         time: 'Sat',
//         type: MessageType.sent,
//       ),
//       MessageData(
//         name: 'Sandra Hernandez',
//         message: 'You: I plunged headlong into QA',
//         time: 'Fri',
//         type: MessageType.sent,
//         isOnline: true,
//       ),
//       MessageData(
//         name: 'Ray Willis',
//         message: 'You: I\'ll be able to read it later',
//         time: 'Wed',
//         type: MessageType.sent,
//         isOnline: true,
//       ),
//       MessageData(
//         name: 'Mary Newman',
//         message: 'Hi, there is a suggestion',
//         time: 'Tue',
//         type: MessageType.inMail,
//       ),
//       MessageData(
//         name: 'Sidney Snyder',
//         message: 'That\'s how linkedin works:)',
//         time: 'Sun',
//       ),
//       MessageData(
//         name: 'Michael Dixon',
//         message: 'You: OK',
//         time: 'Sun',
//         type: MessageType.sent,
//         isOnline: true,
//       ),
//       MessageData(
//         name: 'Joe Howard',
//         message: '👍',
//         time: 'Oct 9',
//       ),
//       MessageData(
//         name: 'Frederick White',
//         message: 'You: Thank you for confirming my...',
//         time: 'Oct 6',
//         type: MessageType.sent,
//         isOnline: true,
//       ),
//     ];
//   }
// }

// // Reusable Message Tile Component
// class MessageTile extends StatelessWidget {
//   final MessageData messageData;
//   final VoidCallback? onTap;

//   const MessageTile({
//     Key? key,
//     required this.messageData,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       leading: UserAvatar(
//         name: messageData.name,
//         avatar: messageData.avatar,
//         isOnline: messageData.isOnline,
//       ),
//       title: Text(
//         messageData.name,
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 16,
//         ),
//       ),
//       subtitle: Padding(
//         padding: EdgeInsets.only(top: 4),
//         child: Row(
//           children: [
//             if (messageData.type == MessageType.inMail)
//               Padding(
//                 padding: EdgeInsets.only(right: 8),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     'InMail',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             Expanded(
//               child: Text(
//                 messageData.message,
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//       trailing: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             messageData.time,
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 12,
//             ),
//           ),
//           SizedBox(height: 4),
//           if (messageData.hasUnreadIndicator)
//             UnreadIndicator(),
//         ],
//       ),
//       onTap: onTap,
//     );
//   }
// }

// // Reusable User Avatar Component
// class UserAvatar extends StatelessWidget {
//   final String name;
//   final String? avatar;
//   final bool isOnline;
//   final double size;

//   const UserAvatar({
//     Key? key,
//     required this.name,
//     this.avatar,
//     this.isOnline = false,
//     this.size = 50,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CircleAvatar(
//           radius: size / 2,
//           backgroundColor: Colors.grey[300],
//           backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
//           child: avatar == null
//               ? Text(
//                   _getInitials(name),
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: size / 3,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               : null,
//         ),
//         if (isOnline)
//           Positioned(
//             right: 0,
//             bottom: 0,
//             child: OnlineIndicator(),
//           ),
//       ],
//     );
//   }

//   String _getInitials(String name) {
//     List<String> names = name.split(' ');
//     String initials = '';
//     for (int i = 0; i < names.length && i < 2; i++) {
//       initials += names[i][0].toUpperCase();
//     }
//     return initials;
//   }
// }

// // Reusable Online Indicator Component
// class OnlineIndicator extends StatelessWidget {
//   final double size;

//   const OnlineIndicator({Key? key, this.size = 12}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: Colors.green,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: Colors.white,
//           width: 2,
//         ),
//       ),
//     );
//   }
// }

// // Reusable Unread Indicator Component
// class UnreadIndicator extends StatelessWidget {
//   final double size;

//   const UnreadIndicator({Key? key, this.size = 8}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_ignite/pages/chatScreen.dart';

// Data model for messages
class MessageData {
  final String name;
  final String message;
  final String time;
  final String? avatar;
  final bool hasUnreadIndicator;
  final bool isOnline;
  final MessageType type;
  final int unreadCount;

  MessageData({
    required this.name,
    required this.message,
    required this.time,
    this.avatar,
    this.hasUnreadIndicator = false,
    this.isOnline = false,
    this.type = MessageType.received,
    this.unreadCount = 0,
  });
}

enum MessageType { sent, received, inMail }

// Main messaging screen with enhanced design
class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';

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
              child: MessagesList(searchQuery: _searchQuery),
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

// Modern App Bar with gradient and blur effect
class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
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
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.search_rounded, color: Colors.white, size: 20),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
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
    Key? key,
    this.hintText = 'Search conversations...',
    this.onChanged,
  }) : super(key: key);

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

// Enhanced Messages List with animations
class MessagesList extends StatelessWidget {
  final List<MessageData>? messages;
  final String searchQuery;

  const MessagesList({Key? key, this.messages, this.searchQuery = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageList = messages ?? _getSampleMessages();
    final filteredMessages = messageList.where((message) =>
        message.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        message.message.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ListView.builder(
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
                // Navigator.push(context,
                //   MaterialPageRoute(
                //     builder: (context) => ChatScreen(), // Replace with actual chat screen
                //   ),
                // );
              },
            ),
          );
        },
      ),
    );
  }

  List<MessageData> _getSampleMessages() {
    return [
      MessageData(
        name: 'Stuart Arnold',
        message: 'Of course send your mail! I\'d be happy to review it.',
        time: '10:07 AM',
        hasUnreadIndicator: true,
        unreadCount: 3,
        isOnline: true,
      ),
      MessageData(
        name: 'Thomas Simmons',
        message: 'You: Perfect! Thanks for the update 👍',
        time: 'Sat',
        type: MessageType.sent,
      ),
      MessageData(
        name: 'Sandra Hernandez',
        message: 'You: I plunged headlong into QA testing today',
        time: 'Fri',
        type: MessageType.sent,
        isOnline: true,
      ),
      MessageData(
        name: 'Ray Willis',
        message: 'You: I\'ll be able to read it later tonight',
        time: 'Wed',
        type: MessageType.sent,
        isOnline: true,
      ),
      MessageData(
        name: 'Mary Newman',
        message: 'Hi, there is a suggestion I\'d like to share with you',
        time: 'Tue',
        type: MessageType.inMail,
        hasUnreadIndicator: true,
        unreadCount: 1,
      ),
      MessageData(
        name: 'Sidney Snyder',
        message: 'That\'s how LinkedIn works! 😄 Great networking',
        time: 'Sun',
        isOnline: true,
      ),
      MessageData(
        name: 'Michael Dixon',
        message: 'You: Sounds good, let\'s proceed with the plan',
        time: 'Sun',
        type: MessageType.sent,
        isOnline: true,
      ),
      MessageData(
        name: 'Joe Howard',
        message: '👍 Absolutely love this idea!',
        time: 'Oct 9',
        hasUnreadIndicator: true,
        unreadCount: 2,
      ),
      MessageData(
        name: 'Frederick White',
        message: 'You: Thank you for confirming my attendance...',
        time: 'Oct 6',
        type: MessageType.sent,
        isOnline: true,
      ),
    ];
  }
}

// Modern Message Tile with enhanced styling and animations
class ModernMessageTile extends StatefulWidget {
  final MessageData messageData;
  final VoidCallback? onTap;
  final int index;

  const ModernMessageTile({
    Key? key,
    required this.messageData,
    this.onTap,
    this.index = 0,
  }) : super(key: key);

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
    Key? key,
    required this.name,
    this.avatar,
    this.isOnline = false,
    this.size = 56,
  }) : super(key: key);

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
          child: avatar != null
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
      initials += names[i][0].toUpperCase();
    }
    return initials;
  }

  List<Color> _getGradientColors(String name) {
    final gradients = [
      [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      [Color(0xFF06B6D4), Color(0xFF3B82F6)],
      [Color(0xFF10B981), Color(0xFF059669)],
      [Color(0xFFF59E0B), Color(0xFFEF4444)],
      [Color(0xFFEC4899), Color(0xBE185D)],
      [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    ];
    return gradients[name.hashCode % gradients.length];
  }
}

// Modern Online Indicator
class ModernOnlineIndicator extends StatelessWidget {
  final double size;

  const ModernOnlineIndicator({Key? key, this.size = 16}) : super(key: key);

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

  const ModernUnreadIndicator({Key? key, this.count = 1}) : super(key: key);

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