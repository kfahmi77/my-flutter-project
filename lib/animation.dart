import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FractalTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const FractalTextAnimation({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.left,
  });

  @override
  createState() => _FractalTextAnimationState();
}

class _FractalTextAnimationState extends State<FractalTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _wordAnimations;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    final words = widget.text.split(' ');
    _wordAnimations = List.generate(
      words.length,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index / words.length,
            (index + 1) / words.length,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.2 && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('fractal-text-${widget.text}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Wrap(
            alignment: widget.textAlign == TextAlign.center
                ? WrapAlignment.center
                : WrapAlignment.start,
            children: _buildAnimatedWords(),
          );
        },
      ),
    );
  }

  List<Widget> _buildAnimatedWords() {
    final words = widget.text.split(' ');
    return List.generate(
      words.length,
      (index) => _buildAnimatedWord(words[index], index),
    );
  }

  Widget _buildAnimatedWord(String word, int index) {
    return AnimatedBuilder(
      animation: _wordAnimations[index],
      builder: (context, child) {
        return Opacity(
          opacity: _wordAnimations[index].value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _wordAnimations[index].value)),
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Text(
                word,
                style: widget.style,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedAboutSection extends StatelessWidget {
  const AnimatedAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          color: Colors.grey[
              900], // Menambahkan warna latar belakang yang sama dengan Experience
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FractalTextAnimation(
                text: 'About Me',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: isDesktop ? null : 30,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: isDesktop ? 50 : 30),
              FractalTextAnimation(
                text:
                    "I'm a passionate Flutter developer and Backend Enthusiast with a keen eye for creating "
                    "beautiful, functional, and user-centered digital experiences. With a background in "
                    "both design and development, I bridge the gap between aesthetics and functionality.",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.8,
                    ),
              ),
              SizedBox(height: isDesktop ? 30 : 20),
              FractalTextAnimation(
                text:
                    "My approach combines clean, efficient code with intuitive design principles to "
                    "deliver apps that not only work flawlessly but also delight users.",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.8,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedExperienceSection extends StatelessWidget {
  const AnimatedExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ExperienceItem> experiences = [
      ExperienceItem(
        title: 'Freelance Mobile Developer',
        company: 'Self-employed',
        duration: '2023 - Present',
        description:
            'Developed custom mobile applications for various clients, focusing on clean code and intuitive user interfaces.',
      ),
      ExperienceItem(
        title: 'Mobile Developer',
        company: 'PUTI (Pusat Teknologi Informasi) Telkom University',
        duration: ' February 2023 -  August 2023',
        description:
            'Developed academic mobile applications for civitas academic Telkom University',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FractalTextAnimation(
                text: 'Experience',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: isDesktop ? null : 30,
                    ),
              ),
              const SizedBox(height: 50),
              ...experiences.map((experience) =>
                  AnimatedExperienceItem(experience: experience)),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedExperienceItem extends StatelessWidget {
  final ExperienceItem experience;

  const AnimatedExperienceItem({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractalTextAnimation(
                  text: experience.title,
                  style: Theme.of(context).textTheme.headlineSmall!,
                ),
                const SizedBox(height: 5),
                FractalTextAnimation(
                  text: '${experience.company} | ${experience.duration}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.grey[400],
                      ),
                ),
                const SizedBox(height: 10),
                FractalTextAnimation(
                  text: experience.description,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        height: 1.8,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceItem {
  final String title;
  final String company;
  final String duration;
  final String description;

  ExperienceItem({
    required this.title,
    required this.company,
    required this.duration,
    required this.description,
  });
}
