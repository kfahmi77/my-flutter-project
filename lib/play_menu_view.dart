import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helpers/database_helper.dart';

class WordPuzzlePage extends StatefulWidget {
  const WordPuzzlePage({super.key});

  @override
  createState() => _WordPuzzlePageState();
}

class _WordPuzzlePageState extends State<WordPuzzlePage>
    with SingleTickerProviderStateMixin {
  final dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> puzzleWords = [];
  Map<String, dynamic> currentWordData = {};
  List<String> shuffledLetters = [];

  final TextEditingController _guessController = TextEditingController();

  int score = 0;
  int health = 3; // New: Initial health
  String hintText = '';

  late AnimationController _controller;
  late Animation<double> _animation;

  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    loadJsonData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isEditing = false;
        });
      }
    });
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
        shuffledLetters = currentWordData['word'].toString().split('')
          ..shuffle();
        _guessController.clear();
        hintText = '';
      });
      _controller.reset();
      _controller.forward();
    }
  }

  void checkAnswer() async {
    if (_guessController.text.toUpperCase() ==
        currentWordData['word'].toString().toUpperCase()) {
      setState(() {
        score += 10;
      });
      _showCustomSnackBar('Correct! Well done!', Colors.green);
      selectNewWord();
    } else {
      _showCustomSnackBar('Incorrect. Try again!', Colors.red);
    }
  }

  // New: Skip word function
  void skipWord() {
    if (health > 0) {
      setState(() {
        health--;
      });
      _showCustomSnackBar('Word skipped. Health decreased!', Colors.orange);
      selectNewWord();
    } else {
      _showGameOverDialog();
    }
  }

  // New: Game over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your final score is $score.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              dbHelper.insertScore(score);
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: const Text('OK', style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
        backgroundColor: const Color(0xFF2D2D44),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _showCustomSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content:
                const Text('Do you want to exit the game and save your score?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No',
                    style: TextStyle(color: Color(0xFFFF6B6B))),
              ),
              TextButton(
                onPressed: () {
                  dbHelper.insertScore(score);
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes',
                    style: TextStyle(color: Color(0xFFFF6B6B))),
              ),
            ],
            backgroundColor: const Color(0xFF2D2D44),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        )) ??
        false;
  }

  @override
  void dispose() {
    dbHelper.insertScore(score);
    _guessController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final result = await _onWillPop();
        if (result) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E2C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2D2D44),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B6B)),
            onPressed: () async {
              final result = await _onWillPop();
              if (result) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Score: $score',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // New: Health display
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Icon(
                      index < health ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: puzzleWords.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF6B6B)))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                        color: const Color(0xFF2D2D44),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeTransition(
                                opacity: _animation,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: shuffledLetters
                                      .map((letter) => _buildLetterTile(letter))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  hintText,
                                  key: ValueKey<String>(hintText),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditing = true;
                        });
                        _focusNode.requestFocus();
                      },
                      child: AbsorbPointer(
                        absorbing: !_isEditing,
                        child: TextField(
                          controller: _guessController,
                          focusNode: _focusNode,
                          readOnly: !_isEditing,
                          showCursor: _isEditing,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Tap to guess the word',
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                            filled: true,
                            fillColor: const Color(0xFF2D2D44),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.edit,
                                color: Color(0xFFFF6B6B)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.lightbulb),
                            label: const Text('HINT'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {
                              setState(() {
                                hintText = "\"${currentWordData['hint'].toString()}\"";
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('SUBMIT'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFFFF6B6B),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: checkAnswer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // New: Skip button
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.skip_next),
                            label: const Text('SKIP'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: skipWord,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLetterTile(String letter) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B6B),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}