// import 'package:flutter/material.dart';

// class Message {
//   final String text;
//   final String time;
//   final bool isSent;
//   final bool hasEmoji;

//   Message({
//     required this.text,
//     required this.time,
//     required this.isSent,
//     this.hasEmoji = false,
//   });
// }

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   List<Message> messages = [
//     Message(
//       text: "Guess I'll go get something to eat at Speedy Chow, I'm just around the corner from your place 😊",
//       time: "16:09",
//       isSent: false,
//     ),
//     Message(
//       text: "Hi!",
//       time: "16:10",
//       isSent: true,
//     ),
//     Message(
//       text: "Awesome thanks for letting me know! Can't wait for my delivery 😊",
//       time: "16:11",
//       isSent: true,
//     ),
//     Message(
//       text: "No problem at all! I'll be there in about 15 minutes.\n\nI'll text you when I arrive.",
//       time: "16:12",
//       isSent: false,
//     ),
//     Message(
//       text: "Great! 😊",
//       time: "16:15",
//       isSent: true,
//       hasEmoji: true,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {},
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage(
//                 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
//               ),
//             ),
//             SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'David Wayne',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   'Last seen 16:01, Sep 5',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.videocam, color: Colors.black),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(Icons.call, color: Colors.black),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(Icons.more_vert, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return MessageBubble(message: messages[index]);
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 top: BorderSide(color: Colors.grey[300]!, width: 0.5),
//               ),
//             ),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.add, color: Colors.grey[600]),
//                   onPressed: () {},
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         hintStyle: TextStyle(color: Colors.grey[500]),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.zero,
//                       ),
//                       maxLines: null,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.send, color: Colors.white, size: 20),
//                     onPressed: () {
//                       _sendMessage();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       setState(() {
//         messages.add(
//           Message(
//             text: _messageController.text.trim(),
//             time: _getCurrentTime(),
//             isSent: true,
//           ),
//         );
//       });
//       _messageController.clear();
//       _scrollToBottom();
//     }
//   }

//   String _getCurrentTime() {
//     final now = DateTime.now();
//     return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final Message message;

//   const MessageBubble({Key? key, required this.message}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment:
//             message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           if (message.isSent) ...[
//             Flexible(
//               child: Container(
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.75,
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(18),
//                     topRight: Radius.circular(18),
//                     bottomLeft: Radius.circular(18),
//                     bottomRight: Radius.circular(4),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       message.text,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           message.time,
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         Icon(
//                           Icons.done_all,
//                           color: Colors.white70,
//                           size: 16,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ] else ...[
//             Flexible(
//               child: Container(
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.75,
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(18),
//                     topRight: Radius.circular(18),
//                     bottomLeft: Radius.circular(4),
//                     bottomRight: Radius.circular(18),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       message.text,
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       message.time,
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class Message {
//   final String text;
//   final String time;
//   final bool isSent;
//   final bool hasEmoji;
//   final bool isDelivered;
//   final bool isRead;

//   Message({
//     required this.text,
//     required this.time,
//     required this.isSent,
//     this.hasEmoji = false,
//     this.isDelivered = true,
//     this.isRead = true,
//   });
// }

// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final String currentID;
//   final String targetID;

//   ChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.currentID,
//     required this.targetID,
//   }) : super(key: key);
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   bool _isTyping = false;

//   List<Message> messages = [];

//   // List<Message> messages = [
//   //   Message(
//   //     text:
//   //         "Guess I'll go get something to eat at Speedy Chow, I'm just around the corner from your place 😊",
//   //     time: "16:09",
//   //     isSent: false,
//   //   ),
//   //   Message(text: "Hi!", time: "16:10", isSent: true),
//   //   Message(
//   //     text: "Awesome thanks for letting me know! Can't wait for my delivery 😊",
//   //     time: "16:11",
//   //     isSent: true,
//   //   ),
//   //   Message(
//   //     text:
//   //         "No problem at all! I'll be there in about 15 minutes.\n\nI'll text you when I arrive.",
//   //     time: "16:12",
//   //     isSent: true,
//   //   ),
//   //   Message(text: "Great! 😊", time: "16:15", isSent: true, hasEmoji: true),
//   // ];

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _scaleController = AnimationController(
//       duration: Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _fadeController.forward();

//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _scaleController.dispose();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FA),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             systemOverlayStyle: SystemUiOverlayStyle.dark,
//             leading: Container(
//               margin: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: IconButton(
//                 icon: Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.black87,
//                   size: 20,
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//             title: Row(
//               children: [
//                 Stack(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         radius: 22,
//                         backgroundImage: NetworkImage(
//                           'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 2,
//                       right: 2,
//                       child: Container(
//                         width: 14,
//                         height: 14,
//                         decoration: BoxDecoration(
//                           color: Color(0xFF4CAF50),
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 2),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'David Wayne',
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         _isTyping ? 'typing...' : 'Active now',
//                         style: TextStyle(
//                           color: _isTyping
//                               ? Color(0xFF007AFF)
//                               : Colors.grey[600],
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: FadeTransition(
//               opacity: _fadeController,
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   return SlideTransition(
//                     position:
//                         Tween<Offset>(
//                           begin: Offset(0, 0.3),
//                           end: Offset.zero,
//                         ).animate(
//                           CurvedAnimation(
//                             parent: _fadeController,
//                             curve: Interval(
//                               (index * 0.1).clamp(0.0, 1.0),
//                               ((index * 0.1) + 0.3).clamp(0.0, 1.0),
//                               curve: Curves.easeOutCubic,
//                             ),
//                           ),
//                         ),
//                     child: MessageBubble(message: messages[index]),
//                   );
//                 },
//               ),
//             ),
//           ),
//           _buildInputArea(),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(IconData icon) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 2),
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: Colors.black87, size: 22),
//         onPressed: () {
//           HapticFeedback.lightImpact();
//         },
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
//         ),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Color(0xFF007AFF).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: IconButton(
//                 icon: Icon(
//                   Icons.add_rounded,
//                   color: Color(0xFF007AFF),
//                   size: 24,
//                 ),
//                 onPressed: () {
//                   HapticFeedback.lightImpact();
//                 },
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(22),
//                   border: Border.all(color: Colors.transparent, width: 1.5),
//                 ),
//                 child: TextField(
//                   controller: _messageController,
//                   onChanged: (value) {
//                     setState(() {
//                       _isTyping = value.isNotEmpty;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Message...',
//                     hintStyle: TextStyle(
//                       color: Colors.grey[500],
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 18,
//                       vertical: 12,
//                     ),
//                   ),
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                   maxLines: 4,
//                   minLines: 1,
//                 ),
//               ),
//             ),
//             SizedBox(width: 12),
//             GestureDetector(
//               onTapDown: (_) => _scaleController.forward(),
//               onTapUp: (_) => _scaleController.reverse(),
//               onTapCancel: () => _scaleController.reverse(),
//               onTap: _sendMessage,
//               child: ScaleTransition(
//                 scale: Tween<double>(
//                   begin: 1.0,
//                   end: 0.95,
//                 ).animate(_scaleController),
//                 child: Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(22),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0xFF007AFF).withOpacity(0.3),
//                         blurRadius: 12,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     Icons.send_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       HapticFeedback.mediumImpact();
//       setState(() {
//         messages.add(
//           Message(
//             text: _messageController.text.trim(),
//             time: _getCurrentTime(),
//             isSent: true,
//           ),
//         );
//         _isTyping = false;
//       });
//       _messageController.clear();
//       _scrollToBottom();
//     }
//   }

//   String _getCurrentTime() {
//     final now = DateTime.now();
//     return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOutCubic,
//         );
//       }
//     });
//   }
// }

// class MessageBubble extends StatefulWidget {
//   final Message message;

//   const MessageBubble({Key? key, required this.message}) : super(key: key);

//   @override
//   _MessageBubbleState createState() => _MessageBubbleState();
// }

// class _MessageBubbleState extends State<MessageBubble>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 3),
//         child: Row(
//           mainAxisAlignment: widget.message.isSent
//               ? MainAxisAlignment.end
//               : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (widget.message.isSent) ...[
//               Flexible(
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.75,
//                   ),
//                   margin: EdgeInsets.only(left: 60),
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(6),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0xFF007AFF).withOpacity(0.2),
//                         blurRadius: 8,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         widget.message.text,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                           height: 1.3,
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             widget.message.time,
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.8),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Icon(
//                             widget.message.isRead
//                                 ? Icons.done_all_rounded
//                                 : Icons.done_rounded,
//                             color: widget.message.isRead
//                                 ? Colors.white
//                                 : Colors.white.withOpacity(0.7),
//                             size: 16,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ] else ...[
//               Flexible(
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.75,
//                   ),
//                   margin: EdgeInsets.only(right: 60),
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                       bottomLeft: Radius.circular(6),
//                       bottomRight: Radius.circular(20),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 8,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.message.text,
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                           height: 1.3,
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Text(
//                         widget.message.time,
//                         style: TextStyle(
//                           color: Colors.grey[500],
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentID;
  final String targetID;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentID,
    required this.targetID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String receiverName = "";
  String receiverProfile = "";
  bool _isTyping = false;
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _loadReceiverData();
    _markMessagesAsRead();
    _typingAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadReceiverData() async {
    try {
      // Step 1: Get the role from the main users collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.targetID)
          .get();

      if (!userDoc.exists) return;

      String role = userDoc['role'] ?? '';
      if (role.isEmpty) return;

      // Step 2: Fetch data from the role-specific table
      DocumentSnapshot roleDoc = await FirebaseFirestore.instance
          .collection(role.toLowerCase()) // e.g., "athlete" or "sponsor"
          .doc(widget.targetID)
          .get();

      if (!roleDoc.exists) return;

      setState(() {
        receiverName = roleDoc['name'] ?? "Unknown";
        receiverProfile = roleDoc['profile'] ?? "";
      });
    } catch (e) {
      print("Error loading receiver data: $e");
    }
  }

  void _markMessagesAsRead() async {
    // Mark all messages from target user as read when opening chat
    QuerySnapshot unreadMessages = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .where('senderId', isEqualTo: widget.targetID)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      doc.reference.update({'isRead': true});
    }
  }

  void _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add haptic feedback
    HapticFeedback.lightImpact();

    final messageRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'senderId': widget.currentID,
      'receiverId': widget.targetID,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    // Update last message in chat
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
          'lastMessage': text,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

    _messageController.clear();

    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final messageTime = timestamp.toDate();
    final difference = now.difference(messageTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                Hero(
                  tag: 'avatar_${widget.targetID}',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: receiverProfile.isNotEmpty
                          ? NetworkImage(receiverProfile)
                          : AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        receiverName.isEmpty ? "Loading..." : receiverName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF667eea),
                          ),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Loading messages...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
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
                          "No messages yet",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Start the conversation!",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == widget.currentID;
                    final timestamp = msg['timestamp'] as Timestamp?;

                    // Show date separator if it's a new day
                    bool showDateSeparator = false;
                    if (index == 0) {
                      showDateSeparator = timestamp != null;
                    } else if (index > 0 && timestamp != null) {
                      final previousTimestamp =
                          messages[index - 1]['timestamp'] as Timestamp?;
                      if (previousTimestamp != null) {
                        final currentDate = timestamp.toDate();
                        final previousDate = previousTimestamp.toDate();
                        showDateSeparator =
                            currentDate.day != previousDate.day ||
                            currentDate.month != previousDate.month ||
                            currentDate.year != previousDate.year;
                      }
                    }

                    return Column(
                      children: [
                        if (showDateSeparator) ...[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              timestamp != null
                                  ? _getDateString(timestamp.toDate())
                                  : '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 3),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isMe
                                        ? LinearGradient(
                                            colors: [
                                              Color(0xFF667eea),
                                              Color(0xFF764ba2),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: isMe ? null : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(
                                        isMe ? 20 : 4,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMe ? 4 : 20,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          msg['text'],
                                          style: TextStyle(
                                            color: isMe
                                                ? Colors.white
                                                : Color(0xFF2D3748),
                                            fontSize: 15,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                      if (isMe) ...[
                                        SizedBox(width: 8),
                                        Icon(
                                          msg['isRead']
                                              ? Icons.done_all
                                              : Icons.check,
                                          size: 16,
                                          color: msg['isRead']
                                              ? Colors.white.withOpacity(0.9)
                                              : Colors.white.withOpacity(0.7),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (timestamp != null) ...[
                                  SizedBox(height: 4),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Text(
                                      _formatTime(timestamp),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FC),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _isTyping
                              ? Color(0xFF667eea).withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          suffixIcon: _isTyping
                              ? null
                              : IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    // Add camera functionality
                                  },
                                ),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF2D3748),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF667eea),
                            Color.fromARGB(255, 75, 82, 162),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF667eea).withOpacity(0.4),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.send, color: Colors.white, size: 20),
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

  String _getDateString(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
