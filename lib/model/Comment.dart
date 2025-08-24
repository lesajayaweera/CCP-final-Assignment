// Comment Tile Widget


// Comment Model
class Comment {
  final String id;
  final String userName;
  final String userAvatar;
  final String comment;
  final String timeAgo;
  final int likes;
  final bool isVerified;
  final bool isCurrentUser;

  Comment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.comment,
    required this.timeAgo,
    this.likes = 0,
    this.isVerified = false,
    this.isCurrentUser = false,
  });
}