import 'package:exam/Screens/history_screen.dart';
import 'package:exam/Screens/owner_selection_screen.dart';
import 'package:flutter/material.dart';
import 'Screens/user_selection_screen.dart';

const String DEFAULT_ROUTE = '/';
const String OWNER_SCREEN = '/owner_screen';
const String USER_SCREEN = '/user_screen';
const String HISTORY_SCREEN = '/history_screen';
const String ADD_SCREEN = '/add_screen';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DEFAULT_ROUTE:
        return MaterialPageRoute(builder: (_) => UserSelectionScreen());
      case OWNER_SCREEN:
        return MaterialPageRoute(builder: (_) => OwnerSelectionScreen());
      case USER_SCREEN:
        return MaterialPageRoute(builder: (_) => UserSelectionScreen());
      case HISTORY_SCREEN:
        return MaterialPageRoute(builder: (_) => HistoryScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
