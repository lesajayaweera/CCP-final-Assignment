import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/LeaderboardService.dart';
import 'package:sport_ignite/pages/profileView.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  String selectedSport = 'All Sports';
  String selectedPosition = 'All Positions';
  late AnimationController _animationController;
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  List<Map<String, dynamic>> _leaderboardData = [];
  bool _isLoading = true;
  String? _error;

  final Map<String, List<String>> sportsPositions = {
    'All Sports': ['All Positions'],
    'Cricket': cricketPositions,
    'Football': footballPositions,
    'Basketball': basketballPositions,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadLeaderboardData();
  }

  void _initializeAnimations() {
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _slideController.forward();
    _bounceController.forward();
  }

  Future<void> _loadLeaderboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await LeaderboardService.getLeaderboard();
      setState(() {
        _leaderboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load leaderboard data: $e';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredPlayers {
    if (_leaderboardData.isEmpty) return [];

    List<Map<String, dynamic>> filtered = List.from(_leaderboardData);

    // Filter by sport
    if (selectedSport != 'All Sports') {
      filtered = filtered
          .where(
            (player) =>
                player['sport']?.toLowerCase() == selectedSport.toLowerCase(),
          )
          .toList();
    }
    if (selectedPosition != 'All Positions') {
      filtered = filtered
          .where(
            (player) =>
                player['positions']?.toLowerCase() ==
                selectedPosition.toLowerCase(),
          )
          .toList();
    }

    return filtered;
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
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadLeaderboardData,
              ),
            ],
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
                                    colors: [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: 20,
                                ),
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
                                selectedPosition =
                                    sportsPositions[selectedSport]![0];
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

          // Loading/Error/Content
          if (_isLoading)
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF667EEA),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading leaderboard...',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_error != null)
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadLeaderboardData,
                      child: Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredPlayers.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 64,
                        color: Color(0xFF94A3B8),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No athletes found',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try adjusting your filters',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
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
                        padding: EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 20,
                        ),
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
                                  child: Icon(
                                    Icons.emoji_events,
                                    color: Color(0xFFFFD700),
                                    size: 24,
                                  ),
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
                                if (filteredPlayers.length > 1)
                                  _buildEnhancedPodiumPlayer(
                                    filteredPlayers[1],
                                    2,
                                  ),
                                if (filteredPlayers.isNotEmpty)
                                  _buildEnhancedPodiumPlayer(
                                    filteredPlayers[0],
                                    1,
                                  ),
                                if (filteredPlayers.length > 2)
                                  _buildEnhancedPodiumPlayer(
                                    filteredPlayers[2],
                                    3,
                                  ),
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
                                      colors: [
                                        Color(0xFF667EEA),
                                        Color(0xFF764BA2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.format_list_numbered,
                                    color: Colors.white,
                                    size: 20,
                                  ),
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
                          ...filteredPlayers
                              .asMap()
                              .entries
                              .map(
                                (entry) => AnimatedContainer(
                                  duration: Duration(
                                    milliseconds: 400 + (entry.key * 100),
                                  ),
                                  curve: Curves.easeOutBack,
                                  child: _buildEnhancedPlayerListItem(
                                    entry.value,
                                    entry.key + 1,
                                  ),
                                ),
                              )
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
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF667EEA),
                size: 24,
              ),
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

  Widget _buildEnhancedPodiumPlayer(Map<String, dynamic> player, int position) {
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

  Widget _buildEnhancedPlayerListItem(
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
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(uid: uid,role: 'Athlete',)));
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
                                  color: _getSportColor(sport).withOpacity(0.3),
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
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
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
                                    color: (position <= 3
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
                                color: _getSportColor(sport).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getSportColor(sport).withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                "${sport.toUpperCase()} \n ${player['positions']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _getSportColor(sport),
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
                        child: Divider(
                          height: 1,
                          color: Colors.grey[200],
                        ),
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
                                children: _buildStatsChips(sport, stats),
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

List<Widget> _buildStatsChips(String sport, Map<String, dynamic> stats) {
  List<Widget> chips = [];

  switch (sport.toLowerCase()) {
    case 'basketball':
      if (stats['Points'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.sports_basketball_rounded,
            label: '${stats['Points']}',
            sublabel: 'Points',
            color: Color(0xFF10B981),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      if (stats['Assists'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.handshake_rounded,
            label: '${stats['Assists']}',
            sublabel: 'Assists',
            color: Color(0xFF3B82F6),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      if (stats['Rebounds'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.all_inclusive_rounded,
            label: '${stats['Rebounds']}',
            sublabel: 'Rebounds',
            color: Color(0xFF8B5CF6),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      break;

    case 'cricket':
      if (stats['Runs'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.sports_cricket_rounded,
            label: '${stats['Runs']}',
            sublabel: 'Runs',
            color: Color(0xFF10B981),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      if (stats['BattingAverage'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.trending_up_rounded,
            label: '${stats['BattingAverage'].toStringAsFixed(1)}',
            sublabel: 'Average',
            color: Color(0xFF3B82F6),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      if (stats['StrikeRate'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.speed_rounded,
            label: '${stats['StrikeRate'].toStringAsFixed(1)}',
            sublabel: 'Strike Rate',
            color: Color(0xFF8B5CF6),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      break;

    case 'football':
      if (stats['Goals'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.sports_soccer_rounded,
            label: '${stats['Goals']}',
            sublabel: 'Goals',
            color: Color(0xFF10B981),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      if (stats['Assists'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.handshake_rounded,
            label: '${stats['Assists']}',
            sublabel: 'Assists',
            color: Color(0xFF3B82F6),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      if (stats['PassAccuracy'] != null) {
        chips.add(
          _buildEnhancedStatChip(
            icon: Icons.assistant_rounded,
            label: '${stats['PassAccuracy'].toStringAsFixed(1)}%',
            sublabel: 'Pass Acc.',
            color: Color(0xFF8B5CF6),
          ),
        );
        chips.add(SizedBox(width: 8));
      }
      break;
  }

  // Remove the last SizedBox if exists
  if (chips.isNotEmpty) {
    chips.removeLast();
  }
  
  return chips;
}

Widget _buildEnhancedStatChip({
  required IconData icon,
  required String label,
  required String sublabel,
  required Color color,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color.withOpacity(0.15),
          color.withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.1),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Color _getSportColor(String sport) {
  switch (sport.toLowerCase()) {
    case 'basketball':
      return Color(0xFFFF6B35);
    case 'cricket':
      return Color(0xFF4CAF50);
    case 'football':
      return Color(0xFF2196F3);
    default:
      return Color(0xFF667EEA);
  }
}

  // Color _getSportColor(String sport) {
  //   switch (sport.toLowerCase()) {
  //     case 'basketball':
  //       return Color(0xFFFF6B35);
  //     case 'cricket':
  //       return Color(0xFF4CAF50);
  //     case 'football':
  //       return Color(0xFF2196F3);
  //     default:
  //       return Color(0xFF667EEA);
  //   }
  // }
}
