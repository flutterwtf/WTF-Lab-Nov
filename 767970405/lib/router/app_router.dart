import 'package:flutter/material.dart';

import '../auth_screen/auth_screen.dart';
import '../filter_screen/filter_screen.dart';
import '../messages_screen/screen_message.dart';
import '../screen_creating_page/create_new_page.dart';
import '../search_messages_screen/search_message_screen.dart';
import '../settings_screen/setting_screen.dart';
import '../statistic_screen/statistic_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ScreenMessage.routeName:
        return _customAnimation(ScreenMessage());
      case CreateNewPage.routName:
        return MaterialPageRoute(
          builder: (context) => CreateNewPage(),
        );
      case SearchMessageScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SearchMessageScreen(),
        );
      case SettingsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        );
      case GeneralOption.routeName:
        return MaterialPageRoute(
          builder: (context) => GeneralOption(),
        );
      case SecurityOption.routeName:
        return MaterialPageRoute(
          builder: (context) => SecurityOption(),
        );
      case AuthScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => AuthScreen(),
        );
      case BackgroundImageScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => BackgroundImageScreen(),
        );
      case FilterScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => FilterScreen(),
        );
      case StatisticScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => StatisticScreen(),
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }

  Route _customAnimation(Widget child) {
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (context, animation, secAnimation, child) {
        return ScaleTransition(
          alignment: Alignment.center,
          scale: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secAnimation) => child,
    );
  }
}
