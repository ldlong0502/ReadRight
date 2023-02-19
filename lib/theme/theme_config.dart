import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = const Color(0xff1f1f1f);
  static Color lightAccent = const Color(0xff32CD32);
  static Color darkAccent = const Color(0xff008000);
  static Color lightSecond = const Color(0xffF5F5F5);
  static Color secondBackground = const Color(0xffF8F5F1);
  static Color authorColor = const Color(0xff757575);
  static Color lightBG = Colors.white;
  static Color darkBG = const Color(0xff121212);

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(background: lightBG),
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      color: lightPrimary,
      elevation: 0.0,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(background: darkBG),
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      color: darkPrimary,
      elevation: 0.0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
  );
}
