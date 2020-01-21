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
            title: Text("Patient"),
            onTap: () =>
                Navigator.pushReplacementNamed(context, PATIENT_SCREEN),
          ),
          ListTile(
            title: Text("Local patients"),
            onTap: () =>
                Navigator.pushReplacementNamed(context, LOCAL_PATIENT_SCREEN),
          ),
          ListTile(
            title: Text("Employee"),
            onTap: () =>
                Navigator.pushReplacementNamed(context, EMPLOYEE_SCREEN),
          ),
          ListTile(
            title: Text("Admin"),
            onTap: () => Navigator.pushReplacementNamed(context, ADMIN_SCREEN),
          ),
        ],
      ),
    );
  }
}
