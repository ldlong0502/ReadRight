import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/theme_config.dart';

const double playerMinHeight = 70;
const miniplayerPercentageDeclaration = 0.2;

class Constants {
  //App related strings
  static String appName = 'ReadRight';
  static BoxDecoration linearDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        ThemeConfig.fourthAccent,
        ThemeConfig.lightAccent,
      ],
    ),
  );

   static BoxDecoration linear1Decoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        ThemeConfig.lightAccent,
        ThemeConfig.fourthAccent,
        
      ],
    ),
  );
  static formatBytes(bytes, decimals) {
    if (bytes == 0) return 0.0;
    var k = 1024,
        dm = decimals <= 0 ? 0 : decimals,
        sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        i = (log(bytes) / log(k)).floor();
    return (((bytes / pow(k, i)).toStringAsFixed(dm)) + ' ' + sizes[i]);
  }

  static double valueFromPercentageInRange(
      {required final double min, max, percentage}) {
    return percentage * (max - min) + min;
  }

  static double percentageFromValueInRange(
      {required final double min, max, value}) {
    return (value - min) / (max - min);
  }
}
