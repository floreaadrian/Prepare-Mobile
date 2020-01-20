import 'package:exam/Screens/client_screen.dart';
import 'package:exam/Screens/employee_screen.dart';
import 'package:exam/Screens/own_games_screen.dart';
import 'package:exam/Screens/rented_games_screen.dart';
import 'package:flutter/material.dart';

const String DEFAULT_ROUTE = '/';
const String CLIENT_SCREEN = '/client_screen';
const String EMPLOYEE_SCREEN = '/employee_screen';
const String OWN_GAMES_SCREEN = '/own_games_screen';
const String RENT_GAMES_SCREEN = '/rent_games_screen';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DEFAULT_ROUTE:
        return MaterialPageRoute(builder: (_) => ClientScreen());
      case CLIENT_SCREEN:
        return MaterialPageRoute(builder: (_) => ClientScreen());
      case EMPLOYEE_SCREEN:
        return MaterialPageRoute(builder: (_) => EmployeeScreen());
      case OWN_GAMES_SCREEN:
        return MaterialPageRoute(builder: (_) => OwnGamesScreen());
      case RENT_GAMES_SCREEN:
        return MaterialPageRoute(builder: (_) => RentedGamesScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
