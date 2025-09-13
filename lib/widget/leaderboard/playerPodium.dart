import 'package:flutter/material.dart';


Widget buildEnhancedPodiumPlayer(Map<String, dynamic> player, int position) {
    List<Color> gradientColors = position == 1
        ? [Color(0xFFFFD700), Color(0xFFFFA500)]
        : position == 2
        ? [Color(0xFFC0C0C0), Color(0xFF999999)]
        : [Color(0xFFCD7F32), Color(0xFFB8860B)];

    double size = position == 1 ? 90 : 75;
    double podiumHeight = position == 1
        ? 90
        : position == 2
        ? 70
        : 60;

    String imageUrl = player['profile'] ?? '';
    String name = player['name'] ?? 'Unknown';
    double score = (player['score'] ?? 0.0).toDouble();
    String uid = player['uid'] ?? 'Unknown';
    print(uid);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (position * 200)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors[0].withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: imageUrl.isEmpty ? Color(0xFF94A3B8) : null,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: imageUrl.isEmpty
                          ? Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: size * 0.4,
                              ),
                            )
                          : null,
                    ),
                  ),
                  if (position == 1)
                    Positioned(
                      top: -5,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: Color(0xFFFFD700),
                          size: 20,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$position',
                          style: TextStyle(
                            color: gradientColors[0],
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: podiumHeight + 20,
                height: podiumHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
                          SizedBox(width: 4),
                          Text(
                            '${score.toInt()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }