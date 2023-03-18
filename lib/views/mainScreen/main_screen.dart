import 'dart:math';

import 'package:ebook/util/const.dart';
import 'package:ebook/views/reading/reading.dart';
import 'package:ebook/views/read/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../../components/slider_menu.dart';
import '../../util/dialogs.dart';
import '../../util/rive_utils.dart';
import '../../view_models/audio_provider.dart';
import '../audio_books/detail_audio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  late SMIBool isSlideBarClosed;
  bool isMenuClosed = true;
  int _page = 0;
  late AnimationController animationController;
  late Animation animation;
  late Animation sclAnimation;
  int _selectedIndex = 0;
  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
  };
  List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      HomePage(
        isMenuClosed: isMenuClosed,
        onPress: onSideMenuPress,
        onRiveInit: riveOnInit,
      ),
      const Reading(),
    ];
    _pageController = PageController(initialPage: 0);
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
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
    double playerMinHeight = 70;
    double playerMaxHeight = MediaQuery.of(context).size.height;
    var miniplayerPercentageDeclaration = 0.2;

    return WillPopScope(
      onWillPop: () => Dialogs().showExitDialog(context),
      child: Container(
        decoration: Constants.linearDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(animation.value - animation.value * 30 * pi / 180),
                  child: Transform.translate(
                    offset: Offset(animation.value * 280, 0),
                    child: Transform.scale(
                      scale: sclAnimation.value,
                      child: ClipRRect(
                          borderRadius: isMenuClosed
                              ? BorderRadius.circular(0)
                              : BorderRadius.circular(20),
                          child: Navigator(
                            key: navigatorKeys[_selectedIndex],
                            onGenerateRoute: (RouteSettings settings) {
                              return MaterialPageRoute(
                                  builder: (_) =>
                                      _widgetOptions.elementAt(_selectedIndex));
                            },
                          )),
                    ),
                  ),
                ),
                Consumer<AudioProvider>(builder: (context, event, _) {
                  return event.getAudioBook() == null
                      ? Container()
                      : DetailAudio(audioBook: event.getAudioBook()!);
                }),
              ],
            ),
            // floatingActionButton:   Consumer<AudioProvider>(
            //   builder: (context, event , _) {
            //    return  event.getAudioBook() == null ? Container() : DetailAudio(audioBook:  event.getAudioBook()!);
            //   }
            // ),
      
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: playerExpandProgress,
              builder: (BuildContext context, double height, Widget? child) {
                final value = Constants.percentageFromValueInRange(
                    min: playerMinHeight,
                    max: MediaQuery.of(context).size.height,
                    value: height);
      
                var opacity = 1 - value;
                if (opacity < 0) opacity = 0;
                if (opacity > 1) opacity = 1;
      
                return SizedBox(
                  height: kBottomNavigationBarHeight -
                      kBottomNavigationBarHeight * value,
                  child: Transform.translate(
                    offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
                    child: Opacity(
                      opacity: opacity,
                      child: OverflowBox(
                        maxHeight: 60,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: BottomNavigationBar(
                backgroundColor: Theme.of(context).primaryColor,
                selectedItemColor: Theme.of(context).colorScheme.secondary,
                unselectedItemColor: Colors.grey[500],
                elevation: 2,
                iconSize: 20,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Trang chủ',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_rounded),
                    label: 'Thư viện',
                  ),
                ],
                onTap: _onItemTapped,
                currentIndex: _selectedIndex,
              ),
            )),
      ),
    );
  }

  void riveOnInit(artboard) {
    StateMachineController? controller = RiveUtils.getRiveController(artboard,
        stateMachineName: "State Machine");
    isSlideBarClosed = controller!.findSMI('isOpen') as SMIBool;
    isSlideBarClosed.value = true;
  }

  void onSideMenuPress() {
    isSlideBarClosed.value = !isSlideBarClosed.value;

    if (isMenuClosed) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    setState(() {
      isMenuClosed = isSlideBarClosed.value;
    });
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
