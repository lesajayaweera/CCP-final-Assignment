import 'package:flutter/material.dart';
import 'package:sport_ignite/pages/profileView.dart';
import 'package:sport_ignite/widget/leaderboard/EnhancedStatsChip.dart';
import 'package:sport_ignite/widget/leaderboard/bluestatChip.dart';

Widget buildEnhancedPlayerListItem(
    Map<String, dynamic> player,
    int position,
  ) {
    String name = player['name'] ?? 'Unknown';
    String uid = player['uid'] ?? 'Unknown';
    String imageUrl = player['profile'] ?? '';
    double score = (player['score'] ?? 0.0).toDouble();
    Map<String, dynamic> stats = player['stats'] ?? {};
    String sport = player['sport'] ?? '';

    // Medal colors for top 3 positions
    final medalColors = [
      Color(0xFFFFD700), // Gold
      Color(0xFFC0C0C0), // Silver
      Color(0xFFCD7F32), // Bronze
    ];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (position * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileView(uid: uid, role: 'Athlete'),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: position <= 3
                      ? LinearGradient(
                          colors: [
                            medalColors[position - 1].withOpacity(0.1),
                            medalColors[position - 1].withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.grey[50]!.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background decoration for top players
                    if (position <= 3)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(
                            Icons.emoji_events,
                            size: 120,
                            color: medalColors[position - 1],
                          ),
                        ),
                      ),

                    Column(
                      children: [
                        // First Row: Player Name Only
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Row(
                            children: [
                              // Player avatar with decorative border
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: getSportColor(
                                      sport,
                                    ).withOpacity(0.3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: imageUrl.isNotEmpty
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: 48,
                                          height: 48,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF667EEA),
                                                        Color(0xFF764BA2),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF667EEA),
                                                Color(0xFF764BA2),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                ),
                              ),

                              SizedBox(width: 16),

                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                    letterSpacing: 0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Second Row: Score, Sport, and Position
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                          child: Row(
                            children: [
                              // Position indicator with medal for top 3
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: position <= 3
                                      ? medalColors[position - 1]
                                      : Color(0xFFF8FAFC),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (position <= 3
                                                  ? medalColors[position - 1]
                                                  : Colors.black)
                                              .withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '$position',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: position <= 3
                                          ? Colors.white
                                          : Color(0xFF475569),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 12),

                              // Sport badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: getSportColor(sport).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: getSportColor(
                                      sport,
                                    ).withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  "${sport.toUpperCase()} \n ${player['positions']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: getSportColor(sport),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),

                              Spacer(),

                              // Score badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF10B981).withOpacity(0.15),
                                      Color(0xFF10B981).withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Color(0xFF10B981).withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: Color(0xFF10B981),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '${score.toInt()}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Divider between profile and stats
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(height: 1, color: Colors.grey[200]),
                        ),

                        // Third Row: Stats
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PERFORMANCE STATS',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[600],
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: buildStatsChips(sport, stats),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }