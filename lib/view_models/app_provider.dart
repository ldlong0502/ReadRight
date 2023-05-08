import 'package:flutter/material.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  BuildContext? _appContext;
  ThemeData theme = ThemeConfig.lightTheme;
  Key? key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get appContext => _appContext!;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  bool _isWelcome = false;

  bool get isWelcome => _isWelcome;

  setWelcome(value , c) async{
    _isWelcome = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('welcome', c);
    notifyListeners();
  }
  void setPageIndex(value) {
    _pageIndex = value;
    notifyListeners();
  }

  void setContext(value) {
    _appContext = value;
    notifyListeners();
  }

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  // change the Theme in the provider and SharedPreferences
  void setTheme(value, c) async {
    theme = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', c);
    notifyListeners();
  }

  ThemeData getTheme(value) {
    return theme;
  }

  Future<ThemeData> checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeData t;
    String r = prefs.getString('theme') ?? 'light';

    t = ThemeConfig.lightTheme;
    setTheme(ThemeConfig.lightTheme, 'light');

    return t;
  }
   Future<void> checkWelcome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String r = prefs.getString('welcome') ?? 'false';
    if(r == 'true') {
      setWelcome(true, 'true');
    }
     else {
      setWelcome(false, 'false');
     } 
  }
}
