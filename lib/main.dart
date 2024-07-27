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
  final List<String> puzzleWords = ['APPLE', 'BEACH', 'CHAIR', 'DANCE', 'EAGLE'];
  late String currentWord;
  late List<String> shuffledLetters;
  final TextEditingController _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectNewWord();
  }

  void selectNewWord() {
    currentWord = puzzleWords[Random().nextInt(puzzleWords.length)];
    shuffledLetters = currentWord.split('')..shuffle();
    _guessController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPuzzleMaster'),
        backgroundColor: Colors.red,
        leading: Icon(Icons.home),
        actions: [
          Icon(Icons.settings),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                      SnackBar(content: Text('First letter is ${currentWord[0]}')),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('SUBMIT'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    if (_guessController.text.toUpperCase() == currentWord) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Correct! Well done!')),
                      );
                      setState(() {
                        selectNewWord();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Incorrect. Try again!')),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}