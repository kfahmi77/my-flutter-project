import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordPuzzleMaster',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WordPuzzlePage(),
    );
  }
}

class WordPuzzlePage extends StatefulWidget {
  const WordPuzzlePage({super.key});

  @override
  _WordPuzzlePageState createState() => _WordPuzzlePageState();
}

class _WordPuzzlePageState extends State<WordPuzzlePage> {
  List<Map<String, dynamic>> puzzleWords = [];
  Map<String, dynamic> currentWordData = {};
  List<String> shuffledLetters = [];
  final TextEditingController _guessController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPuzzleMaster'),
        backgroundColor: Colors.red,
        leading: const Icon(Icons.home),
        actions: const [
          Icon(Icons.settings),
        ],
      ),
      body: puzzleWords.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        const Text('Puzzle Board', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: shuffledLetters.map((letter) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.white,
                            ),
                            child: Center(child: Text(letter, style: const TextStyle(fontSize: 24))),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _guessController,
                    decoration: InputDecoration(
                      hintText: 'Guess the word',
                      border: const OutlineInputBorder(),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(currentWordData['hint'].toString())),
                          );
                        },
                        child: const Text('HINT'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          if (_guessController.text.toUpperCase() == currentWordData['word'].toString().toUpperCase()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Correct! Well done!')),
                            );
                            setState(() {
                              selectNewWord();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Incorrect. Try again!')),
                            );
                          }
                        },
                        child: const Text('SUBMIT'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}