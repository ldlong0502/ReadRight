import 'package:flutter/material.dart';

class TextMove extends StatefulWidget {
  const TextMove({super.key, required this.title});
  final String title;
  @override
  State<TextMove> createState() => _TextMoveState();
}

class _TextMoveState extends State<TextMove>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final double containerWidth = 200.0;
  final double containerHeight = 200.0;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();

    _animation = Tween<double>(
            begin: 0, end: containerWidth )
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, _) {
        return Transform.translate(
          offset: Offset(-_animation.value, 0),
          child: Text(widget.title)
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
