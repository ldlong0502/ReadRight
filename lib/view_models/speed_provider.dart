import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeedProvider extends ChangeNotifier {
  SpeedProvider() {
    checkSpeed();
  }

  double speed = 1.0;
  double getSpeed() {
    return speed;
  }

  void setSpeed(value) async {
    speed = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('speed', value.toString());
    notifyListeners();
  }

  Future<double> checkSpeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double t;
    String r = prefs.getString('speed') ?? '1.0';
    t = double.parse(r);
    setSpeed(t);
    return t;
  }
}
