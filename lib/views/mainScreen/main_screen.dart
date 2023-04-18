
import 'package:ebook/util/const.dart';
import 'package:ebook/view_models/app_provider.dart';
import 'package:ebook/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../../util/dialogs.dart';
import '../../util/rive_utils.dart';
import '../../view_models/audio_provider.dart';
import '../audio_books/audio_book_player.dart';
import '../book_library/book_library.dart';

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
  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
  };
  List<Widget> _widgetOptions = <Widget>[];

  

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AppProvider>(context, listen: false)
          .setContext(context),
    );
    _widgetOptions = [
      HomePage(
        isMenuClosed: isMenuClosed,
        onPress: onSideMenuPress,
        onRiveInit: riveOnInit,
      ),
      const BookLibrary(),
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
    
    return Consumer<AppProvider>(
      builder: (context, event, _) {
        final selectedIndex = event.pageIndex;
        return WillPopScope(
          onWillPop: () => Dialogs().showExitDialog(context),
          child: Container(
            decoration: Constants.linearDecoration,
            child: Scaffold(
              backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Navigator(
                                key: navigatorKeys[selectedIndex],
                                onGenerateRoute: (RouteSettings settings) {
                                  return MaterialPageRoute(
                                      builder: (_) =>
                                          _widgetOptions.elementAt(selectedIndex));
                                },
                              ),
                    Consumer<AudioProvider>(builder: (context, event, _) {
                      return event.getAudioBook() == null
                          ? Container()
                          : AudioBookPlayer(audioBook: event.getAudioBook()!);
                    }),
                  ],
                ),
                
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
                    onTap: (value) { event.setPageIndex(value);},
                    currentIndex: selectedIndex,
                  ),
                )),
          ),
        );
      }
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
