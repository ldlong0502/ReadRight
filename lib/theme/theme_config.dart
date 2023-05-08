import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  // static Color lightAccent = const Color(0xff108dc7 );
  static Color fourthAccent = const Color(0xfff4d03f);
  static Color secondAccent = const Color(0xffff8c00);
  static Color thirdAccent = const Color(0xff405070);
  static Color lightSecond = const Color(0xff3f4f6e);
  // static Color fourthAccent = const Color(0xffef8e38);
  static Color lightAccent = const Color(0xff16a085);
  static Color secondBackground = const Color(0xffF8F5F1);
  static Color authorColor = const Color(0xff757575);
  static Color lightBG = Colors.white;

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(background: lightBG),
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      color: lightPrimary,
      elevation: 0.0,
      titleTextStyle:  TextStyle(
        color: lightAccent,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme:  IconThemeData(
        color: lightAccent,
      ),
    ),
  );

 
}
