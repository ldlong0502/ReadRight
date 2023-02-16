
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FallingImage extends StatefulWidget {
  final String imagePath;
  final double top;
  final double left;

  const FallingImage({
    Key? key,
    required this.imagePath,
    required this.top,
    required this.left,
  }) : super(key: key);

  @override
  _FallingImageState createState() => _FallingImageState();
}

class _FallingImageState extends State<FallingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _imageTop = 0.0;
  final double _imageLeft = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.top,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {
          _imageTop = _animation.value;
        });
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _imageTop,
      left: widget.left,
      child: Transform.rotate(
        angle: - pi / 9,
        child: SvgPicture.asset(
          widget.imagePath,
          height: 110,
          width: 200,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
