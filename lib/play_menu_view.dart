import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordPuzzlePage extends StatefulWidget {
  @override
  _WordPuzzlePageState createState() => _WordPuzzlePageState();
}

class _WordPuzzlePageState extends State<WordPuzzlePage> {
  List<Map<String, dynamic>> puzzleWords = [];
  Map<String, dynamic> currentWordData = {};
  List<String> shuffledLetters = [];
  final TextEditingController _guessController = TextEditingController();
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/jsons/word_data.json');
    List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      puzzleWords = List<Map<String, dynamic>>.from(jsonData);
      selectNewWord();
    });
  }

  void selectNewWord() {
    if (puzzleWords.isNotEmpty) {
      currentWordData = puzzleWords[Random().nextInt(puzzleWords.length)];
      shuffledLetters = currentWordData['word'].toString().split('')..shuffle();
      _guessController.clear();
    }
  }

  Future<void> saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList('highscores') ?? [];
    scores.add(score.toString());
    await prefs.setStringList('highscores', scores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPuzzleMaster'),
        backgroundColor: Colors.red,
      ),
      body: puzzleWords.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Score: $score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        Text('Puzzle Board', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: shuffledLetters.map((letter) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.white,
                            ),
                            child: Center(child: Text(letter, style: TextStyle(fontSize: 24))),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _guessController,
                    decoration: InputDecoration(
                      hintText: 'Guess the word',
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('HINT'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(currentWordData['hint'].toString())),
                          );
                        },
                      ),
                      ElevatedButton(
                        child: Text('SUBMIT'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          if (_guessController.text.toUpperCase() == currentWordData['word'].toString().toUpperCase()) {
                            setState(() {
                              score += 10;
                              selectNewWord();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Correct! Well done!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Incorrect. Try again!')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('End Game'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      await saveScore();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}