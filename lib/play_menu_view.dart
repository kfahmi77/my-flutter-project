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
  String hintText = '';

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonString =
        await rootBundle.loadString('assets/jsons/word_data.json');
    List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      puzzleWords = List<Map<String, dynamic>>.from(jsonData);
      selectNewWord();
    });
  }

  void selectNewWord() {
    if (puzzleWords.isNotEmpty) {
      setState(() {
        currentWordData = puzzleWords[Random().nextInt(puzzleWords.length)];
        shuffledLetters = currentWordData['word'].toString().split('')..shuffle();
        _guessController.clear();
        hintText = '';
      });
    }
  }

  Future<void> saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastScore', score);
  }

  void checkAnswer() async {
    if (_guessController.text.toUpperCase() ==
        currentWordData['word'].toString().toUpperCase()) {
      setState(() {
        score += 10;
      });
      await saveScore();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correct! Well done!')),
      );
      selectNewWord(); // Reset for next word
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect. Try again!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPuzzleMaster'),
        backgroundColor: Colors.red,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $score',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: puzzleWords.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: shuffledLetters
                                  .map((letter) => Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                            child: Text(letter,
                                                style: const TextStyle(
                                                    fontSize: 20))),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              hintText,
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _guessController,
                    decoration: InputDecoration(
                      hintText: 'Guess the word',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: const Text('HINT'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            setState(() {
                              hintText = currentWordData['hint'].toString();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text('SUBMIT'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: checkAnswer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}