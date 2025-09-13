import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/LeaderboardService.dart';
import 'package:sport_ignite/widget/leaderboard/playerListItem.dart';
import 'package:sport_ignite/widget/leaderboard/playerPodium.dart';

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
     _loadPreferredSport();
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

  Future<void> _loadPreferredSport() async {
  try {
    final sport = await LeaderboardService.getUserPreferredSport();
    if (mounted) {
      setState(() {
        selectedSport = sport; // 👈 now dropdown defaults to saved sport
        selectedPosition = sportsPositions[selectedSport]![0];
      });
    }
  } catch (e) {
    print("Error fetching sportIntrested: $e");
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
                            (value) async {
                              setState(() {
                                selectedSport = value!;
                                selectedPosition =
                                    sportsPositions[selectedSport]![0];
                              });
                              await LeaderboardService.saveUserPreferredSport(selectedSport);
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
                                  buildEnhancedPodiumPlayer(
                                    filteredPlayers[1],
                                    2,
                                  ),
                                if (filteredPlayers.isNotEmpty)
                                  buildEnhancedPodiumPlayer(
                                    filteredPlayers[0],
                                    1,
                                  ),
                                if (filteredPlayers.length > 2)
                                  buildEnhancedPodiumPlayer(
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
                                  child: buildEnhancedPlayerListItem(
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

  

  

  
}
