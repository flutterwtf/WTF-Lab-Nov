import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/home_screen/home_page.dart';
import 'theme/cubit_theme.dart';
import 'theme/screens_theme.dart';
import 'theme/states_theme.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => CubitTheme(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<CubitTheme>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StateWidget(
        child: Builder(
          builder: (context) {
            return BlocBuilder<CubitTheme, StatesTheme>(
                builder: (context, state) => MaterialApp(
                      title: 'Events',
                      theme: state.themeData,
                      home: HomePage(),
                    ));
          },
        ),
      );
}
