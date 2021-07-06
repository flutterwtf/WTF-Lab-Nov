import 'package:flutter/material.dart';

enum MyThemeKeys {
  light,
  dark,
}

// ignore: avoid_classes_with_only_static_members
class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF2929DB),
    backgroundColor: Color(0xFFFFFFFF),
    primaryColorLight: Color(0xFFF0F8FF),
    accentColor: Color(0xFFFFC20C),
    buttonColor: Color(0xFF2929DB),
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF213244),
    backgroundColor: Color(0xFF1E2832),
    primaryColorLight: Color(0xFF213244),
    accentColor: Color(0xFFFFC20C),
    buttonColor: Color(0xFFFFC20C),
    brightness: Brightness.dark,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.light:
        return lightTheme;
      case MyThemeKeys.dark:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
