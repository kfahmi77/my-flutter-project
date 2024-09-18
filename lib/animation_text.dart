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

class _FragileGatherTextAnimationState extends State<FragileGatherTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;
  final List<Offset> _finalPositions = [];
  final List<Offset> _randomPositions = [];
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..addStatusListener(_updateAnimatingStatus);

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  void _updateAnimatingStatus(AnimationStatus status) {
    setState(() {
      _isAnimating = status == AnimationStatus.forward ||
          status == AnimationStatus.reverse;
    });
  }

  double _calculateResponsiveFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 24.0; // Untuk mobile
    } else if (screenWidth < 1200) {
      return 32.0; // Untuk tablet
    } else {
      return 52.0; // Untuk desktop
    }
  }

  double _calculateResponsiveLetterSpacing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 20.0; // Untuk mobile
    } else if (screenWidth < 1200) {
      return 40.0; // Untuk tablet
    } else {
      return 60.0; // Untuk desktop
    }
  }

  void _setupAnimations(double letterSpacing) {
    final random = math.Random();
    double totalWidth = widget.text.length * letterSpacing;
    double startX = -totalWidth / 2;

    _finalPositions.clear();
    _randomPositions.clear();
    _animations = List.generate(widget.text.length, (index) {
      final finalPosition = Offset(startX + index * letterSpacing, 0);
      _finalPositions.add(finalPosition);

      final randomPosition = Offset(
        (random.nextDouble() - 0.5) * 300,
        (random.nextDouble() - 0.5) * 300,
      );
      _randomPositions.add(randomPosition);

      return Tween(
        begin: randomPosition,
        end: finalPosition,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ));
    });
  }

  void _toggleAnimation() {
    if (_isAnimating) return;

    if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    } else if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_updateAnimatingStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double letterSpacing = _calculateResponsiveLetterSpacing(context);
    double fontSize = _calculateResponsiveFontSize(context);

    _setupAnimations(letterSpacing);

    return GestureDetector(
      onTap: _toggleAnimation,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.text.length * letterSpacing,
        height: fontSize * 2,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(widget.text.length, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _animations[index].value,
                  child: Text(
                    widget.text[index],
                    style: widget.textStyle.copyWith(
                      color: widget.textStyle.color!
                          .withOpacity(_controller.value),
                      fontSize: fontSize,
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
