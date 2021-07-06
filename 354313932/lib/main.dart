import 'package:flutter/material.dart';

import 'config/custom_theme.dart';
import 'constants/themes.dart';
import 'pages/home/home_screen.dart';

void main() async {
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.light,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Journal',
      theme: CustomTheme.of(context),
      home: HomeScreen(),
    );
  }
}
