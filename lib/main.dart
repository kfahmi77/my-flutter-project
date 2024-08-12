import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'play_menu_view.dart';
import 'score_view.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Teka TekiKu',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainMenuPage(),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AnimatedTitle(),
                const SizedBox(height: 50),
                MenuButton(
                  title: 'Main',
                  icon: Icons.play_arrow,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WordPuzzlePage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                MenuButton(
                  title: 'Skor tertinggi',
                  icon: Icons.emoji_events,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HighscorePage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                MenuButton(
                  title: 'Pengaturan',
                  icon: Icons.settings,
                  onPressed: () {
                   //buat dialog sedang dalam pengembangan
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Pengaturan'),
                          content: const Text('Sedang dalam pengembangan'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedTitle extends StatelessWidget {
  const AnimatedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: const Column(
        children: [
          Text(
            'Teka Teki',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B6B),
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Color(0xFFFF6B6B),
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
          Text(
            'Ku',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const MenuButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2D2D44),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: const Color(0xFFFF6B6B).withOpacity(0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}