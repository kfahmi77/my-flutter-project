import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data untuk leaderboard
    final List<Map<String, dynamic>> leaderboardData = [
      {'rank': 1, 'name': 'Alex', 'score': 10000},
      {'rank': 2, 'name': 'Beth', 'score': 9500},
      {'rank': 3, 'name': 'Charlie', 'score': 9000},
      {'rank': 4, 'name': 'David', 'score': 8500},
      {'rank': 5, 'name': 'Emma', 'score': 8000},
      {'rank': 6, 'name': 'Frank', 'score': 7500},
      {'rank': 7, 'name': 'Grace', 'score': 7000},
      {'rank': 8, 'name': 'Henry', 'score': 6500},
      {'rank': 9, 'name': 'Ivy', 'score': 6000},
      {'rank': 10, 'name': 'Jack', 'score': 5500},
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'LEADERBOARD',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48), // untuk menyeimbangkan layout
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboardData.length,
                  itemBuilder: (context, index) {
                    final entry = leaderboardData[index];
                    final isTopThree = entry['rank'] <= 3;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isTopThree
                            ? _getColorForRank(entry['rank'])
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            '${entry['rank']}',
                            style: GoogleFonts.roboto(
                              color: _getColorForRank(entry['rank']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          entry['name'],
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Text(
                          '${entry['score']}',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForRank(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade300;
      case 3:
        return Colors.brown.shade300;
      default:
        return Colors.white.withOpacity(0.1);
    }
  }
}