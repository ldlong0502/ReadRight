

import 'package:ebook/util/const.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/app_provider.dart';
import 'package:ebook/views/mainScreen/main_screen.dart';
import 'package:ebook/views/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if(context.read<AppProvider>().isWelcome) {
        MyRouter.pushReplacementAnimation(context, const MainScreen());
      }
      else{
        MyRouter.pushReplacementAnimation(context, const WelcomeScreen());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: Constants.linearDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: Image.asset('assets/images/logo.png' , fit: BoxFit.cover, height: 50,)),
              const SizedBox(height: 30,),
              const SpinKitSpinningLines(
                color: Colors.orange,
                size: 50,
              )
    
            ],
          ),
        ),
      ),
    );
  }
}