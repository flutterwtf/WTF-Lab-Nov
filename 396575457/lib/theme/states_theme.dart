import 'package:flutter/material.dart';

class StatesTheme {
  final bool isLightTheme;
  final ThemeData themeData;

  StatesTheme({
    this.isLightTheme,
    this.themeData,
  });

  StatesTheme copyWith({
    final bool isLightTheme,
    final ThemeData themeData,
  }) {
    return StatesTheme(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      themeData: themeData ?? this.themeData,
    );
  }

  StatesTheme get lightTheme {
    return StatesTheme(
      isLightTheme: true,
      themeData: ThemeData(
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
      ),
    );
  }

  StatesTheme get darkTheme {
    return StatesTheme(
      isLightTheme: false,
      themeData: ThemeData(
        cardColor: Colors.white,
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
      ),
    );
  }
}
