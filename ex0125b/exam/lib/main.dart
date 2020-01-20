import 'package:exam/Providers/client_provider.dart';
import 'package:exam/Providers/employee_provider.dart';
import 'package:exam/Screens/client_screen.dart';
import 'package:exam/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database_creator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ClientProvider>.value(value: ClientProvider()),
        ChangeNotifierProvider<EmployeeProvider>.value(
            value: EmployeeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Router.generateRoute,
      home: ClientScreen(),
    );
  }
}
