import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SlideButton extends StatelessWidget {
  const SlideButton({
    super.key,
    required this.press,
    required this.riveOnInt,
  });
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInt;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          height: 40,
          width: 40,
          child: RiveAnimation.asset(
            'assets/RiveAssets/menu_button.riv',
            onInit: riveOnInt,
            
          ),
        ),
      ),
    );
  }
}
