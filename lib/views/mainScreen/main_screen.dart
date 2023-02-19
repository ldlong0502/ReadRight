


import 'dart:math';

import 'package:ebook/components/slider_menu.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/views/favorite/favorite.dart';
import 'package:ebook/views/read/read.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../components/slide_button.dart';
import '../../util/dialogs.dart';
import '../../util/rive_utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>  with SingleTickerProviderStateMixin{
  late PageController _pageController;
  late SMIBool isSlideBarClosed;
  bool isMenuClosed = true;
  int _page = 0;
  late AnimationController animationController;
  late Animation animation;
  late Animation sclAnimation;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))..addListener(() {setState(() {
      
    });});

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn) );
    sclAnimation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
  }
  @override
  void dispose() {
    animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Dialogs().showExitDialog(context),
      child: Scaffold(
        backgroundColor: ThemeConfig.lightAccent,
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width: 288,
              left: isMenuClosed ? -300 : 0,
              height: MediaQuery.of(context).size.height,
              child: const SliderMenu()),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - animation.value * 30 * pi /180),
              child: Transform.translate(
                offset:  Offset(animation.value * 280 ,0),
                child: Transform.scale(
                  scale: sclAnimation.value,
                  child: ClipRRect(
                    borderRadius: isMenuClosed ?BorderRadius.circular(0)  : BorderRadius.circular(20),
                    child: PageView(
                      
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: onPageChanged,
                      children:  <Widget>[Read(ctx: context), Favorite()],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              top: 6,
              left: isMenuClosed ?  12 : 200,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: SlideButton(
                
                riveOnInt: (artboard) {
                  StateMachineController? controller = RiveUtils.getRiveController(artboard , stateMachineName: "State Machine");
                  isSlideBarClosed = controller!.findSMI('isOpen') as SMIBool;
                  isSlideBarClosed.value = true;
                },
                press: () {
                  isSlideBarClosed.value = !isSlideBarClosed.value;
                  
                  if(isMenuClosed){
                    animationController.forward();
                  }
                  else{
                    animationController.reverse();
                  }
                  setState(() {
                    isMenuClosed = isSlideBarClosed.value;
                  });
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.grey[500],
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              label: 'My favorite',
            ),
            
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }


  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
}

