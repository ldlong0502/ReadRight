import 'package:ebook/components/falling_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/route.dart';
import '../mainScreen/main_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _opacity = 0.0;
   double _opacityButton = 0.0;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 1.0;
        _opacityButton = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                  Colors.amberAccent, BlendMode.softLight),
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
                height: size.height,
                width: size.width,
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(150)),
                    height: 300,
                  ),
                  const FallingImage(
                      imagePath: 'assets/icons/read.svg', top: 50, left: 20),
                  Positioned(
                    top: 100,
                    left: 100,
                    child: AnimatedOpacity(
                        opacity: _opacity,
                        duration: const Duration(seconds: 2),
                        child: SvgPicture.asset(
                          'assets/icons/people.svg',
                          height: 120,
                          width: 120,
                        )),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 130,
                    child: AnimatedOpacity(
                        opacity: _opacityButton,
                        duration: const Duration(seconds: 3),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_outlined), 
                          onPressed: (){
                             MyRouter.pushPageReplacement(
                                context,
                               const  MainScreen(),
                              );
                          },))
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
