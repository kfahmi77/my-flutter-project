import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighscorePage extends StatelessWidget {
  const HighscorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highscores'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<int>>(
        future: getHighscores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<int> scores = snapshot.data ?? [];
            return ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Score: ${scores[index]}'),
                  leading: Text('#${index + 1}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<int>> getHighscores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList('highscores') ?? [];
    return scores.map((score) => int.parse(score)).toList()
      ..sort((a, b) => b.compareTo(a));
  }
}
