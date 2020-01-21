import 'package:exam/Screens/admin_screen.dart';
import 'package:exam/Screens/patian_screen.dart';
import 'package:exam/Screens/records_screen.dart';
import 'package:flutter/material.dart';

import 'Screens/employee_screen.dart';
import 'Screens/local_patient_screen.dart';

const String DEFAULT_ROUTE = '/';
const String PATIENT_SCREEN = '/patient_screen';
const String EMPLOYEE_SCREEN = '/employee_screen';
const String LOCAL_PATIENT_SCREEN = '/local_patient_screen';
const String RECORDS_SCREEN = '/records_screen';
const String ADMIN_SCREEN = '/admin_screen';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DEFAULT_ROUTE:
        return MaterialPageRoute(builder: (_) => PatientScreen());
      case PATIENT_SCREEN:
        return MaterialPageRoute(builder: (_) => PatientScreen());
      case LOCAL_PATIENT_SCREEN:
        return MaterialPageRoute(builder: (_) => LocalPatientScreen());
      case EMPLOYEE_SCREEN:
        return MaterialPageRoute(builder: (_) => EmployeeScreen());
      case ADMIN_SCREEN:
        return MaterialPageRoute(builder: (_) => AdminScreen());
      case RECORDS_SCREEN:
        var data = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => RecordsScreen(
                  id: data,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
