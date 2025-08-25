import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedSport = 'Cricket';
  String selectedPosition = 'Batsman';

  final Map<String, List<String>> sportsPositions = {
    'Cricket': ['Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper'],
    'Football': ['Forward', 'Midfielder', 'Defender', 'Goalkeeper'],
    'Basketball': [
      'Point Guard',
      'Shooting Guard',
      'Small Forward',
      'Power Forward',
      'Center'
    ],
  };

  // Dummy player data for testing
  final List<Player> dummyPlayers = [
    Player('John Doe', 45,
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400'),
    Player('Jane Smith', 42,
        'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=400'),
    Player('Mike Johnson', 40,
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'),
    Player('Sarah Connor', 38,
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400'),
    Player('You', 36,
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400'),
    Player('Chris Lee', 34,
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400'),
  ];

  List<Player> get currentPlayers {
    // Right now using dummy data for every sport & position
    return dummyPlayers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      
      body: Column(
        children: [
          // Sport and Position Filter
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Sport Selection
                Row(
                  children: [
                    Text('Sport: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSport,
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSport = newValue!;
                                selectedPosition =
                                    sportsPositions[selectedSport]![0];
                              });
                            },
                            items: sportsPositions.keys
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Position Selection
                Row(
                  children: [
                    Text('Position: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedPosition,
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPosition = newValue!;
                              });
                            },
                            items: sportsPositions[selectedSport]!
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top 3 Podium
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (currentPlayers.length > 1)
                          _buildPodiumPlayer(currentPlayers[1], 2),
                        if (currentPlayers.isNotEmpty)
                          _buildPodiumPlayer(currentPlayers[0], 1),
                        if (currentPlayers.length > 2)
                          _buildPodiumPlayer(currentPlayers[2], 3),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  // Remaining Players List
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: currentPlayers
                          .asMap()
                          .entries
                          .skip(3)
                          .map((entry) =>
                              _buildPlayerListItem(entry.value, entry.key + 1))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlayer(Player player, int position) {
    Color borderColor = position == 1
        ? Color(0xFF9ACD32)
        : position == 2
            ? Colors.grey[400]!
            : Colors.orange[300]!;

    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 3),
            image: DecorationImage(
              image: NetworkImage(player.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: borderColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$position',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          player.name,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Color(0xFF9ACD32), size: 16),
            SizedBox(width: 2),
            Text(
              '${player.points} pts',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerListItem(Player player, int position) {
    bool isCurrentUser = player.name == 'You';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Color(0xFF9ACD32).withOpacity(0.1)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            child: Text(
              '$position',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isCurrentUser
                  ? Border.all(color: Color(0xFF9ACD32), width: 2)
                  : null,
              image: DecorationImage(
                image: NetworkImage(player.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              player.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    isCurrentUser ? FontWeight.w600 : FontWeight.w500,
                color: isCurrentUser ? Color(0xFF9ACD32) : Colors.black,
              ),
            ),
          ),
          Text(
            '${player.points} pts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isCurrentUser ? Color(0xFF9ACD32) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class Player {
  final String name;
  final int points;
  final String imagePath;

  Player(this.name, this.points, this.imagePath);
}


