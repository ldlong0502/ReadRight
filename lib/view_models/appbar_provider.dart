
import 'package:flutter/material.dart';

class AppBarProvider extends ChangeNotifier {

 
  bool _isHome = true;

  bool get isHome => _isHome;

  
  void setEventTriggered(bool value) {
    _isHome = value;
    notifyListeners();
  }

}
