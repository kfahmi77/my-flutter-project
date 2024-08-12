import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helpers/database_helper.dart';

class HighscorePage extends StatelessWidget {
  HighscorePage({super.key});
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Skor Tertinggi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 246, 246, 249),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getHighscores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B6B)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else {
            List<Map<String, dynamic>> scores = snapshot.data ?? [];
            scores = scores.where((score) => score['score'] > 0).toList();
            scores.sort((a, b) => b['score'].compareTo(a['score']));
            
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Skor Tertinggi',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.white.withOpacity(0.3),
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return AnimatedScoreCard(
                        rank: index + 1,
                        score: scores[index]['score'],
                        index: index,
                      );
                    },
                    childCount: scores.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class AnimatedScoreCard extends StatelessWidget {
  final int rank;
  final int score;
  final int index;

  const AnimatedScoreCard({
    super.key,
    required this.rank,
    required this.score,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFF2D2D44),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getColor(rank),
            child: Text(
              '$rank',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            'Skor: $score',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(_getIcon(rank), color: _getColor(rank)),
        ),
      ),
    );
  }

  Color _getColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[300]!;
      case 3:
        return Colors.brown[300]!;
      default:
        return const Color(0xFFFF6B6B);
    }
  }

  IconData _getIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.star;
      case 3:
        return Icons.whatshot;
      default:
        return Icons.thumb_up;
    }
  }
}