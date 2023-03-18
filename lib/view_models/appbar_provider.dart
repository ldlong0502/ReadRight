
import 'package:flutter/material.dart';

class AppBarProvider extends ChangeNotifier {

  int tab_index = 0;

  int get tabIndex => tab_index;
  bool _isHome = true;

  bool get isHome => _isHome;

  void setTabIndex(int value) {
    tab_index = value;
    notifyListeners();
  }
  void setEventTriggered(bool value) {
    _isHome = value;
    notifyListeners();
  }

}
