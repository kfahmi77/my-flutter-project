import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Ujian Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExamPage(),
    );
  }
}

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  int timeLeft = 3600; // 60 menit dalam detik
  late Timer timer;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    startTimer();
  }

  void loadQuestions() async {
    String jsonString = await rootBundle.loadString('assets/questions.json');
    List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      questions = List<Map<String, dynamic>>.from(jsonList);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          showResult();
        }
      });
    });
  }

  void answerQuestion(String selectedAnswer) {
    if (questions[currentQuestionIndex]['correctAnswer'] == selectedAnswer) {
      score++;
    }

    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        showResult();
      }
    });
  }

  void showResult() {
    timer.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hasil Ujian'),
          content: Text('Skor Anda: $score / ${questions.length}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
                resetExam();
              },
            ),
          ],
        );
      },
    );
  }

  void resetExam() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      timeLeft = 3600;
    });
    startTimer();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Ujian Mobile'),
      ),
      drawer: Drawer(
        child: questions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Soal ${index + 1}'),
                    tileColor: currentQuestionIndex == index ? Colors.blue[100] : null,
                    onTap: () {
                      setState(() {
                        currentQuestionIndex = index;
                      });
                      Navigator.pop(context); // Close the drawer
                    },
                  );
                },
              ),
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Waktu Tersisa: ${formatTime(timeLeft)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Soal ${currentQuestionIndex + 1} dari ${questions.length}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    questions[currentQuestionIndex]['question'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (questions[currentQuestionIndex]['options'] as List<dynamic>).length,
                      itemBuilder: (context, idx) {
                        String option = questions[currentQuestionIndex]['options'][idx].toString();
                        String label = String.fromCharCode(65 + idx); // A, B, C, D
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () => answerQuestion(option),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('$label. $option'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}