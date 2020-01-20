import 'package:exam/Providers/owner_provider.dart';
import 'package:exam/Screens/user_selection_screen.dart';
import 'package:exam/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/user_provider.dart';
import 'database_creator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: UserProvider()),
        ChangeNotifierProvider<OwnerProvider>.value(value: OwnerProvider()),
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
      onGenerateRoute: Router.generateRoute,
      home: UserSelectionScreen(),
    );
  }
}
