import 'package:exam/Providers/patient_provider.dart';
import 'package:exam/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/employee_provider.dart';
import 'Screens/patian_screen.dart';
import 'database_creator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PatientProvider>.value(value: PatientProvider()),
        ChangeNotifierProvider<EmployeeProvider>.value(
            value: EmployeeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Router.generateRoute,
      home: PatientScreen(),
    );
  }
}
