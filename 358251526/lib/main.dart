import 'package:flutter/material.dart';

import 'domain.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class _ThemeChanger extends InheritedWidget {
  final _ThemeChangerState data;

  const _ThemeChanger({
    required this.data,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static _ThemeChanger of(BuildContext context) {
    final _ThemeChanger? result =
        context.dependOnInheritedWidgetOfExactType<_ThemeChanger>();
    assert(result != null, 'No ThemeChanger found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_ThemeChanger old) {
    print('updateShouldNotify');
    return true;
  }
}

class ThemeChanger extends StatefulWidget {
  final Widget child;
  final bool islight;
  const ThemeChanger({Key? key, required this.child, required this.islight}) : super(key: key);

  @override
  _ThemeChangerState createState() => _ThemeChangerState();

  static bool of(BuildContext context){
    return _ThemeChanger.of(context).data.isLight;
  }

  static _ThemeChangerState instanceOf(BuildContext context){
    return _ThemeChanger.of(context).data;
  }
}

class _ThemeChangerState extends State<ThemeChanger> {
  late bool isLight;

  void changeTheme(){
    setState(() {
      isLight = !isLight;
    });
  }

  @override
  void initState() {
    isLight = widget.islight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeChanger(data: this, child: widget.child);
  }
}


class Myyyyyy extends StatefulWidget {
  const Myyyyyy({Key? key}) : super(key: key);

  @override
  _MyyyyyyState createState() => _MyyyyyyState();
}

class _MyyyyyyState extends State<Myyyyyy> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      themeMode:
      ThemeChanger.of(context)? ThemeMode.light : ThemeMode.dark,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeChanger(
        islight: true,
        child: Myyyyyy()
    );
  }
}