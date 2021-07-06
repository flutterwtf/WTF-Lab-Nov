import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens_theme_tracker.dart';

class StateWidget extends StatefulWidget {
  final Widget child;

  const StateWidget({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  _StateWidgetState createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  bool isDefaultThemeChosen = true;
  ThemeData currentTheme = ScreensThemeTracker().lightTheme;

  bool changeTheme() {
    isDefaultThemeChosen = !isDefaultThemeChosen;
    setState(() {
      currentTheme = isDefaultThemeChosen
          ? ScreensThemeTracker().lightTheme
          : ScreensThemeTracker().darkTheme;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) => ScreensThemeState(
        child: widget.child,
        isDefaultThemeChosen: isDefaultThemeChosen,
        stateWidget: this,
      );
}

class ScreensThemeState extends InheritedWidget {
  final bool isDefaultThemeChosen;
  final _StateWidgetState stateWidget;

  ScreensThemeState({
    Key key,
    Widget child,
    this.isDefaultThemeChosen,
    this.stateWidget,
  }) : super(key: key, child: child);

  static _StateWidgetState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ScreensThemeState>()
      .stateWidget;

  @override
  bool updateShouldNotify(ScreensThemeState oldWidget) =>
      oldWidget.isDefaultThemeChosen != isDefaultThemeChosen;
}
