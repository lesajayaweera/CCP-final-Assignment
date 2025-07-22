import 'package:flutter/material.dart';

// Data model for messages
class MessageData {
  final String name;
  final String message;
  final String time;
  final String? avatar;
  final bool hasUnreadIndicator;
  final bool isOnline;
  final MessageType type;

  MessageData({
    required this.name,
    required this.message,
    required this.time,
    this.avatar,
    this.hasUnreadIndicator = false,
    this.isOnline = false,
    this.type = MessageType.received,
  });
}

enum MessageType { sent, received, inMail }

// Main messaging screen
class MessagingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MessagingAppBar(),
      body: Column(
        children: [
          SearchBar(),
          Expanded(
            child: MessagesList(),
          ),
        ],
      ),
    );
  }
}

// Reusable App Bar Component
class MessagingAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Messaging',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Reusable Search Bar Component
class SearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchBar({
    Key? key,
    this.hintText = 'Search messages',
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey[600]),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.tune, color: Colors.grey[600]),
        ),
      ),
    );
  }
}

// Main Messages List Component
class MessagesList extends StatelessWidget {
  final List<MessageData>? messages;

  const MessagesList({Key? key, this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageList = messages ?? _getSampleMessages();
    
    return ListView.builder(
      itemCount: messageList.length,
      itemBuilder: (context, index) {
        return MessageTile(
          messageData: messageList[index],
          onTap: () {
            // Handle message tap
            print('Tapped on ${messageList[index].name}');
          },
        );
      },
    );
  }

  // Sample data - replace with your actual data
  List<MessageData> _getSampleMessages() {
    return [
      MessageData(
        name: 'Stuart Arnold',
        message: 'Of course send your mail',
        time: '10:07 AM',
        hasUnreadIndicator: true,
      ),
      MessageData(
        name: 'Thomas Simmons',
        message: 'You: OK',
        time: 'Sat',
        type: MessageType.sent,
      ),
      MessageData(
        name: 'Sandra Hernandez',
        message: 'You: I plunged headlong into QA',
        time: 'Fri',
        type: MessageType.sent,
        isOnline: true,
      ),
      MessageData(
        name: 'Ray Willis',
        message: 'You: I\'ll be able to read it later',
        time: 'Wed',
        type: MessageType.sent,
        isOnline: true,
      ),
      MessageData(
        name: 'Mary Newman',
        message: 'Hi, there is a suggestion',
        time: 'Tue',
        type: MessageType.inMail,
      ),
      MessageData(
        name: 'Sidney Snyder',
        message: 'That\'s how linkedin works:)',
        time: 'Sun',
      ),
      MessageData(
        name: 'Michael Dixon',
        message: 'You: OK',
        time: 'Sun',
        type: MessageType.sent,
        isOnline: true,
      ),
      MessageData(
        name: 'Joe Howard',
        message: '👍',
        time: 'Oct 9',
      ),
      MessageData(
        name: 'Frederick White',
        message: 'You: Thank you for confirming my...',
        time: 'Oct 6',
        type: MessageType.sent,
        isOnline: true,
      ),
    ];
  }
}

// Reusable Message Tile Component
class MessageTile extends StatelessWidget {
  final MessageData messageData;
  final VoidCallback? onTap;

  const MessageTile({
    Key? key,
    required this.messageData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: UserAvatar(
        name: messageData.name,
        avatar: messageData.avatar,
        isOnline: messageData.isOnline,
      ),
      title: Text(
        messageData.name,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Row(
          children: [
            if (messageData.type == MessageType.inMail)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'InMail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Text(
                messageData.message,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            messageData.time,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          if (messageData.hasUnreadIndicator)
            UnreadIndicator(),
        ],
      ),
      onTap: onTap,
    );
  }
}

// Reusable User Avatar Component
class UserAvatar extends StatelessWidget {
  final String name;
  final String? avatar;
  final bool isOnline;
  final double size;

  const UserAvatar({
    Key? key,
    required this.name,
    this.avatar,
    this.isOnline = false,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.grey[300],
          backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
          child: avatar == null
              ? Text(
                  _getInitials(name),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: size / 3,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: OnlineIndicator(),
          ),
      ],
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
}

// Reusable Online Indicator Component
class OnlineIndicator extends StatelessWidget {
  final double size;

  const OnlineIndicator({Key? key, this.size = 12}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
    );
  }
}

// Reusable Unread Indicator Component
class UnreadIndicator extends StatelessWidget {
  final double size;

  const UnreadIndicator({Key? key, this.size = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }
}

