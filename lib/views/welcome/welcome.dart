import 'package:ebook/util/route.dart';
import 'package:ebook/views/on_boarding/on_boarding.dart';
import 'package:flutter/material.dart';

import '../../theme/theme_config.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: size.height * 0.5,
            ),
            Container(
              height: size.height * 0.45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[350]!.withOpacity(0.5)),
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                 
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.fill,
                                  height: 40,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'ReadRight',
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 20 , right: 10),
                      child: Text(
                        'Trải nghiệm không giới hạn với hàng ngàn cuốn sách, nâng cao khả năng sử dụng ngôn từ của bạn.',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                         MyRouter.pushReplacementAnimation(context,  const OnBoardingPage());
                      },
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 50,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [ThemeConfig.fourthAccent, Colors.redAccent],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Bắt đầu',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                    ),
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
