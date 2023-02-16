import 'package:ebook/theme/theme_config.dart';
import 'package:flutter/material.dart';

class TwoSideRoundedButton extends StatelessWidget {
  final String text;
  final double radius;
  final Function press;

  const TwoSideRoundedButton({super.key, required this.text, this.radius = 29, required this.press});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => press,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: ThemeConfig.lightAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
