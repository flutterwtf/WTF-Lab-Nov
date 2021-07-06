import 'dart:ui';

import 'package:flutter/material.dart';

class ScreensThemeTracker {
  ThemeData get lightTheme {
    return ThemeData(
      cardColor: Colors.blueGrey[100],
      primarySwatch: Colors.blue,
      accentColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.yellow,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
      appBarTheme: AppBarTheme(
        color: Colors.blue,
        centerTitle: true,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      textSelectionColor: Colors.white,
      brightness: Brightness.dark,
      accentColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.yellow,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
      ),
    );
  }
}
