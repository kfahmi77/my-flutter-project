import 'package:flutter/material.dart';
import 'dart:math' as math;

class FragileGatherTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  const FragileGatherTextAnimation({
    super.key,
    required this.text,
    required this.textStyle,
  });

  @override
   createState() => _FragileGatherTextAnimationState();
}

class _FragileGatherTextAnimationState extends State<FragileGatherTextAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;
  final List<Offset> _finalPositions = [];
  final List<Offset> _randomPositions = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..addListener(() => setState(() {}));

    _setupAnimations();

    // Start the animation automatically after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  void _setupAnimations() {
    final random = math.Random();
    double totalWidth = widget.text.length * 20.0;
    double startX = -totalWidth / 2;

    _animations = List.generate(widget.text.length, (index) {
      final finalPosition = Offset(startX + index * 20.0, 0);
      _finalPositions.add(finalPosition);
      
      final randomPosition = Offset(
        (random.nextDouble() - 0.5) * 200,
        (random.nextDouble() - 0.5) * 200,
      );
      _randomPositions.add(randomPosition);

      return Tween<Offset>(
        begin: randomPosition,
        end: finalPosition,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.status == AnimationStatus.dismissed) {
          _controller.forward();
        } else if (_controller.status == AnimationStatus.completed) {
          _controller.reverse();
        }
      },
      child: SizedBox(
        width: widget.text.length * 20.0,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(widget.text.length, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Transform.translate(
                  offset: _animations[index].value,
                  child: Text(
                    widget.text[index],
                    style: widget.textStyle.copyWith(
                      color: widget.textStyle.color!.withOpacity(_controller.value),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}