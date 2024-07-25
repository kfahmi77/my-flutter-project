import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/database_helper.dart';
import 'models/leader_board_model.dart';

class PlayMenuView extends StatefulWidget {
  const PlayMenuView({super.key});

  @override
  createState() => _PlayMenuViewState();
}

class _PlayMenuViewState extends State<PlayMenuView>
    with SingleTickerProviderStateMixin {
  static const int rows = 20;
  static const int cols = 10;
  List<List<int>> board = List.generate(rows, (_) => List.filled(cols, 0));
  List<List<int>> currentPiece = [];
  List<List<int>> nextPiece = [];
  int currentPieceRow = 0;
  int currentPieceCol = 0;
  int score = 0;
  bool isGameOver = false;
  Timer? timer;
  int currentColorIndex = 0;
  int nextColorIndex = 0;

  List<Color> pieceColors = [
    const Color(0xFF1ABC9C), // Turquoise
    const Color(0xFF3498DB), // Blue
    const Color(0xFFF1C40F), // Yellow
    const Color(0xFFE74C3C), // Red
    const Color(0xFF9B59B6), // Purple
    const Color(0xFF2ECC71), // Green
    const Color(0xFFE67E22), // Orange
  ];

  late AudioPlayer backgroundMusicPlayer;
  late AudioPlayer buttonSoundPlayer;
  late AudioPlayer gameOverSoundPlayer;

  late AnimationController _animationController;

  List<List<List<int>>> tetrisPieces = [
    [
      [1, 1],
      [1, 1]
    ], // O
    [
      [1, 1, 1, 1]
    ], // I
    [
      [1, 1, 1],
      [0, 1, 0]
    ], // T
    [
      [1, 1, 1],
      [1, 0, 0]
    ], // L
    [
      [1, 1, 1],
      [0, 0, 1]
    ], // J
    [
      [1, 1, 0],
      [0, 1, 1]
    ], // S
    [
      [0, 1, 1],
      [1, 1, 0]
    ], // Z
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    initAudio();
    startGame();
  }

  void initAudio() async {
    backgroundMusicPlayer = AudioPlayer();
    buttonSoundPlayer = AudioPlayer();
    gameOverSoundPlayer = AudioPlayer();

    await backgroundMusicPlayer
        .setSource(AssetSource('sounds/background_music.mp3'));
    await backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundMusicPlayer.setVolume(0.5);
    backgroundMusicPlayer.resume();
  }

  void playButtonSound() async {
    await buttonSoundPlayer.setSource(AssetSource('sounds/button_click.mp3'));
    buttonSoundPlayer.resume();
  }

  void playGameOverSound() async {
    await gameOverSoundPlayer.setSource(AssetSource('sounds/game_over.mp3'));
    gameOverSoundPlayer.resume();
  }

  void startGame() {
    setState(() {
      board = List.generate(rows, (_) => List.filled(cols, 0));
      score = 0;
      isGameOver = false;
      nextPiece = getRandomPiece();
      nextColorIndex = Random().nextInt(pieceColors.length);
    });
    spawnNewPiece();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      update();
    });
  }

  List<List<int>> getRandomPiece() {
    return tetrisPieces[Random().nextInt(tetrisPieces.length)];
  }

  void spawnNewPiece() {
    currentPiece = nextPiece;
    currentColorIndex = nextColorIndex;
    currentPieceRow = 0;
    currentPieceCol = cols ~/ 2 - currentPiece[0].length ~/ 2;

    nextPiece = getRandomPiece();
    nextColorIndex = Random().nextInt(pieceColors.length);

    if (!isValidMove(currentPieceRow, currentPieceCol)) {
      setState(() {
        isGameOver = true;
      });
      timer?.cancel();
      showGameOverDialog();
    }
  }

  bool isValidMove(int row, int col, [List<List<int>>? piece]) {
    piece = piece ?? currentPiece;
    for (int i = 0; i < piece.length; i++) {
      for (int j = 0; j < piece[i].length; j++) {
        if (piece[i][j] != 0) {
          if (row + i >= rows ||
              col + j < 0 ||
              col + j >= cols ||
              board[row + i][col + j] != 0) {
            return false;
          }
        }
      }
    }
    return true;
  }

  bool tryWallKick(List<List<int>> rotatedPiece) {
    // Original position
    if (isValidMove(currentPieceRow, currentPieceCol, rotatedPiece)) {
      return true;
    }

    // Try to move right
    if (isValidMove(currentPieceRow, currentPieceCol + 1, rotatedPiece)) {
      currentPieceCol++;
      return true;
    }

    // Try to move left
    if (isValidMove(currentPieceRow, currentPieceCol - 1, rotatedPiece)) {
      currentPieceCol--;
      return true;
    }

    // Try to move up (for I piece mostly)
    if (isValidMove(currentPieceRow - 1, currentPieceCol, rotatedPiece)) {
      currentPieceRow--;
      return true;
    }

    // If all fails, return false
    return false;
  }

  void update() {
    if (!isValidMove(currentPieceRow + 1, currentPieceCol)) {
      placePiece();
      clearLines();
      spawnNewPiece();
    } else {
      setState(() {
        currentPieceRow++;
      });
    }
  }

  void placePiece() {
    for (int i = 0; i < currentPiece.length; i++) {
      for (int j = 0; j < currentPiece[i].length; j++) {
        if (currentPiece[i][j] != 0) {
          board[currentPieceRow + i][currentPieceCol + j] =
              currentColorIndex + 1;
        }
      }
    }
  }

  void clearLines() {
    List<int> linesToClear = [];
    for (int i = 0; i < rows; i++) {
      if (board[i].every((cell) => cell != 0)) {
        linesToClear.add(i);
      }
    }

    if (linesToClear.isNotEmpty) {
      setState(() {
        for (int line in linesToClear) {
          board.removeAt(line);
          board.insert(0, List.filled(cols, 0));
        }
        score += linesToClear.length * 100;
      });
    }
  }

  void moveLeft() {
    playButtonSound();
    if (isValidMove(currentPieceRow, currentPieceCol - 1)) {
      setState(() {
        currentPieceCol--;
      });
    }
  }

  void moveRight() {
    playButtonSound();
    if (isValidMove(currentPieceRow, currentPieceCol + 1)) {
      setState(() {
        currentPieceCol++;
      });
    }
  }

  void rotate() {
    playButtonSound();
    List<List<int>> rotatedPiece = List.generate(
      currentPiece[0].length,
      (i) => List.generate(currentPiece.length,
          (j) => currentPiece[currentPiece.length - 1 - j][i]),
    );

    if (tryWallKick(rotatedPiece)) {
      setState(() {
        currentPiece = rotatedPiece;
      });
    }
  }

  void drop() {
    playButtonSound();
    while (isValidMove(currentPieceRow + 1, currentPieceCol)) {
      setState(() {
        currentPieceRow++;
      });
    }
    update();
  }

  Widget buildNextPiecePreview() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 16,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) {
          int row = index ~/ 4;
          int col = index % 4;
          bool isFilled = row < nextPiece.length &&
              col < nextPiece[0].length &&
              nextPiece[row][col] != 0;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color:
                  isFilled ? pieceColors[nextColorIndex] : Colors.transparent,
            ),
          );
        },
      ),
    );
  }

  void showGameOverDialog() {
    playGameOverSound();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String playerName = '';
        return AlertDialog(
          title: Text('GAME OVER', style: GoogleFonts.pressStart2p()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your score: $score',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 20),
              TextField(
                style: GoogleFonts.roboto(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: GoogleFonts.roboto(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  playerName = value;
                },
              ),
            ],
          ),
          backgroundColor: const Color(0xFF34495E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              child: Text('SAVE & RESTART',
                  style: GoogleFonts.roboto(color: Colors.white)),
              onPressed: () async {
                if (playerName.isNotEmpty) {
                  await DatabaseHelper.instance.insertEntry(
                      LeaderboardEntry(name: playerName, score: score));
                }
                Navigator.of(context).pop();
                startGame();
              },
            ),
            TextButton(
              child:
                  Text('EXIT', style: GoogleFonts.roboto(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Exit to main menu
              },
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SCORE',
                            style: GoogleFonts.roboto(
                                fontSize: 18, color: Colors.white70)),
                        Text('$score',
                            style: GoogleFonts.pressStart2p(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('NEXT',
                            style: GoogleFonts.roboto(
                                fontSize: 18, color: Colors.white70)),
                        const Padding(padding: EdgeInsets.only(top: 8)),
                        buildNextPiecePreview(),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: cols / rows,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rows * cols,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                        ),
                        itemBuilder: (context, index) {
                          int row = index ~/ cols;
                          int col = index % cols;
                          int cellValue = board[row][col];

                          if (row >= currentPieceRow &&
                              row < currentPieceRow + currentPiece.length &&
                              col >= currentPieceCol &&
                              col < currentPieceCol + currentPiece[0].length) {
                            if (currentPiece[row - currentPieceRow]
                                    [col - currentPieceCol] !=
                                0) {
                              cellValue = currentColorIndex + 1;
                            }
                          }

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              color: cellValue == 0
                                  ? Colors.transparent
                                  : pieceColors[cellValue - 1],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(Icons.rotate_left, rotate, 'Rotate'),
                    Column(
                      children: [
                        Row(
                          children: [
                            _buildControlButton(
                                Icons.arrow_left, moveLeft, 'Left'),
                            const SizedBox(width: 10),
                            _buildControlButton(
                                Icons.arrow_right, moveRight, 'Right'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildControlButton(
                            Icons.arrow_drop_down, drop, 'Drop'),
                      ],
                    ),
                    _buildControlButton(Icons.rotate_right, rotate, 'Rotate'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(
      IconData icon, VoidCallback onPressed, String label) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
        playButtonSound();
      },
      onTapUp: (_) {
        _animationController.reverse();
        onPressed();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        ),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF34495E),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              Text(
                label,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    backgroundMusicPlayer.dispose();
    buttonSoundPlayer.dispose();
    gameOverSoundPlayer.dispose();
    super.dispose();
  }
}
