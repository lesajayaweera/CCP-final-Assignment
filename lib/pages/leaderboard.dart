import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  String selectedSport = 'Cricket';
  String selectedPosition = 'Batsman';
  late AnimationController _animationController;
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  final Map<String, List<String>> sportsPositions = {
    'Cricket': cricketPositions,
    'Football': footballPositions,
    'Basketball': basketballPositions,
     
    
  };

  final List<Player> dummyPlayers = [
    Player('John Doe', 45,
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400',
        PlayerStats(matches: 28, wins: 24, goals: 156, winRate: 85.7)),
    Player('Jane Smith', 42,
        'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=400',
        PlayerStats(matches: 25, wins: 21, goals: 142, winRate: 84.0)),
    Player('Mike Johnson', 40,
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
        PlayerStats(matches: 30, wins: 24, goals: 138, winRate: 80.0)),
    Player('Sarah Connor', 38,
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
        PlayerStats(matches: 26, wins: 20, goals: 124, winRate: 76.9)),
    Player('Alex Rodriguez', 36,
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
        PlayerStats(matches: 24, wins: 18, goals: 118, winRate: 75.0)),
    Player('Chris Lee', 34,
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
        PlayerStats(matches: 22, wins: 16, goals: 102, winRate: 72.7)),
  ];

  List<Player> get currentPlayers => dummyPlayers;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    _bounceAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
    _slideController.forward();
    _bounceController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar with Glassmorphism
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFF0F0F0)],
                ).createShader(bounds),
                child: Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                      Color(0xFFF093FB),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            elevation: 0,
          ),

          // Enhanced Filter Section with Glassmorphism
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: 0,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.tune, color: Colors.white, size: 20),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Filter Rankings',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A202C),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          _buildEnhancedDropdown(
                            'Sport',
                            selectedSport,
                            sportsPositions.keys.toList(),
                            Icons.sports_soccer,
                            (value) {
                              setState(() {
                                selectedSport = value!;
                                selectedPosition = sportsPositions[selectedSport]![0];
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          _buildEnhancedDropdown(
                            'Position',
                            selectedPosition,
                            sportsPositions[selectedSport]!,
                            Icons.person,
                            (value) {
                              setState(() {
                                selectedPosition = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Enhanced Podium with 3D effects
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _bounceAnimation,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF667EEA),
                            Color(0xFF764BA2),
                            Color(0xFFF093FB),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF667EEA).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 0,
                            offset: Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.emoji_events, 
                                  color: Color(0xFFFFD700), size: 24),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Top Performers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (currentPlayers.length > 1)
                                _buildEnhancedPodiumPlayer(currentPlayers[1], 2),
                              if (currentPlayers.isNotEmpty)
                                _buildEnhancedPodiumPlayer(currentPlayers[0], 1),
                              if (currentPlayers.length > 2)
                                _buildEnhancedPodiumPlayer(currentPlayers[2], 3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Enhanced Rankings List
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 0,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.format_list_numbered, 
                                  color: Colors.white, size: 20),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Full Rankings',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A202C),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...currentPlayers
                            .asMap()
                            .entries
                            .map((entry) => AnimatedContainer(
                                  duration: Duration(milliseconds: 400 + (entry.key * 100)),
                                  curve: Curves.easeOutBack,
                                  child: _buildEnhancedPlayerListItem(
                                      entry.value, entry.key + 1),
                                ))
                            .toList(),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDropdown(
    String label,
    String value,
    List<String> items,
    IconData icon,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5568),
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, 
                color: Color(0xFF667EEA), size: 24),
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A202C),
              ),
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, size: 16, color: Color(0xFF667EEA)),
                      ),
                      SizedBox(width: 10),
                      Text(item),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedPodiumPlayer(Player player, int position) {
    List<Color> gradientColors = position == 1
        ? [Color(0xFFFFD700), Color(0xFFFFA500)]
        : position == 2
            ? [Color(0xFFC0C0C0), Color(0xFF999999)]
            : [Color(0xFFCD7F32), Color(0xFFB8860B)];

    double size = position == 1 ? 90 : 75;
    double podiumHeight = position == 1 ? 90 : position == 2 ? 70 : 60;

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
                        image: DecorationImage(
                          image: NetworkImage(player.imagePath),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
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
                      player.name,
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
                            '${player.points}',
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

  Widget _buildEnhancedPlayerListItem(Player player, int position) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (position * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: position <= 3 
                  ? Color(0xFF667EEA).withOpacity(0.05)
                  : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: position <= 3 
                    ? Color(0xFF667EEA).withOpacity(0.2)
                    : Colors.transparent,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: position <= 3
                        ? LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          )
                        : LinearGradient(
                            colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                          ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: position <= 3 
                            ? Color(0xFF667EEA).withOpacity(0.3)
                            : Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$position',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: position <= 3 ? Colors.white : Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        player.imagePath,
                        fit: BoxFit.cover,
                        width: 56,
                        height: 56,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A202C),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildEnhancedStatChip(
                              icon: Icons.sports_score,
                              label: '${player.stats.goals}',
                              sublabel: _getGoalLabel(),
                              color: Color(0xFF10B981),
                            ),
                            _buildEnhancedStatChip(
                              icon: Icons.trending_up,
                              label: '${player.stats.winRate.toStringAsFixed(1)}%',
                              sublabel: 'Win Rate',
                              color: Color(0xFF3B82F6),
                            ),
                            _buildEnhancedStatChip(
                              icon: Icons.confirmation_number,
                              label: '${player.stats.matches}',
                              sublabel: 'Matches',
                              color: Color(0xFF8B5CF6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedStatChip({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                sublabel,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGoalLabel() {
    switch (selectedSport.toLowerCase()) {
      case 'cricket':
        return 'Runs';
      case 'football':
        return 'Goals';
      case 'basketball':
        return 'Points';
      default:
        return 'Score';
    }
  }
}

class Player {
  final String name;
  final int points;
  final String imagePath;
  final PlayerStats stats;

  Player(this.name, this.points, this.imagePath, this.stats);
}

class PlayerStats {
  final int matches;
  final int wins;
  final int goals; // or runs/points scored depending on sport
  final double winRate;

  PlayerStats({
    required this.matches,
    required this.wins,
    required this.goals,
    required this.winRate,
  });
}