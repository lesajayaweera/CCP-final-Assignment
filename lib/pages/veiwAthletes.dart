import 'package:flutter/material.dart';
import 'package:sport_ignite/widget/common/bottomNavigation.dart';

class AthletesScreen extends StatefulWidget {

  const AthletesScreen({Key? key}) : super(key: key);

  @override
  State<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Athletes you may know from',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: const SizedBox(), // Remove back button
      ),
      body: Column(
        children: [
          Text('Athletes you May Know'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                return AthleteCard(athlete: athletes[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex:_currentIndex, role: 'Sponsor', onTap:(index) {
        setState(() {
             _currentIndex= index;
          });
       }),
    );
  }
}

class AthleteCard extends StatelessWidget {
  final Athletes athlete;

  const AthleteCard({Key? key, required this.athlete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Profile Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(athlete.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Name
                Text(
                  athlete.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Sport/Position
                Text(
                  athlete.sport,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                // Club/Team info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(athlete.clubLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        athlete.club,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Connect Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Connected with ${athlete.name}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue[700],
                      side: BorderSide(color: Colors.blue[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Close button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                // Optional: add remove logic
              },
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Athletes {
  final String name;
  final String sport;
  final String club;
  final String imagePath;
  final String clubLogo;

  Athletes({
    required this.name,
    required this.sport,
    required this.club,
    required this.imagePath,
    required this.clubLogo,
  });
}

// Sample data
final List<Athletes> athletes = [
  Athletes(
    name: 'Veronica Symo...',
    sport: 'Foot ball player',
    club: 'Lomonosov Moscow State',
    imagePath: 'asset/image/profile.jpg',
    clubLogo: 'asset/image/background.png',
  ),
  Athletes(
    name: 'Veronica Symo...',
    sport: 'Foot ball player',
    club: 'Lomonosov Moscow State',
    imagePath: 'asset/image/profile.jpg',
    clubLogo: 'asset/image/background.png',
  ),
  Athletes(
    name: 'Veronica Symo...',
    sport: 'Foot ball player',
    club: 'Lomonosov Moscow State',
    imagePath: 'asset/image/profile.jpg',
    clubLogo: 'asset/image/background.png',
  ),
  Athletes(
    name: 'Alexey Makovs...',
    sport: 'Junior football player',
    club: 'Lomonosov Moscow State',
    imagePath: 'asset/image/profile.jpg',
    clubLogo: 'asset/image/background.png',
  ),
  Athletes(
    name: 'Michael Riley',
    sport: 'Foot ball player',
    club: 'Local Club',
    imagePath: 'asset/image/profile.jpg',
    clubLogo: 'asset/image/background.png',
  ),
  Athletes(
    name: 'Daniel Jenkins',
    sport: 'National level Batsman',
    club: 'Cricket Academy',
    imagePath: 'asset/image/profile.jpg',
    clubLogo: 'asset/image/background.png',
  ),
];
