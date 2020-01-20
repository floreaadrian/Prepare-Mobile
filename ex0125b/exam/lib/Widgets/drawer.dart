import 'package:flutter/material.dart';

import '../routes.dart';

class OurDrawer extends StatelessWidget {
  const OurDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.wb_sunny),
                Text('Navigate the app'),
              ],
            )),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            title: Text("Client"),
            onTap: () => Navigator.pushReplacementNamed(context, CLIENT_SCREEN),
          ),
          ListTile(
            title: Text("Bought games"),
            onTap: () =>
                Navigator.pushReplacementNamed(context, OWN_GAMES_SCREEN),
          ),
          ListTile(
            title: Text("Rented games"),
            onTap: () =>
                Navigator.pushReplacementNamed(context, RENT_GAMES_SCREEN),
          ),
          ListTile(
            title: Text("Employee"),
            onTap: () =>
                Navigator.pushReplacementNamed(context, EMPLOYEE_SCREEN),
          ),
        ],
      ),
    );
  }
}
