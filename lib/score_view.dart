import 'package:flutter/material.dart';

import 'helpers/database_helper.dart';

class HighscorePage extends StatelessWidget {
   HighscorePage({super.key});
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highscores'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getHighscores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> scores = snapshot.data ?? [];
            return ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                if (scores[index]['score'] == 0) {
                  return const SizedBox();
                }
                return ListTile(
                  title: Text('Score: ${scores[index]['score']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}