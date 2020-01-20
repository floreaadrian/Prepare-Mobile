import 'package:flutter/material.dart';

import '../routes.dart';

class OurDrawer extends StatelessWidget {
  const OurDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  USER_SCREEN,
                );
              },
              child: Container(
                color: Colors.red,
                child: Icon(Icons.person),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  OWNER_SCREEN,
                );
              },
              child: Container(
                color: Colors.green,
                child: Icon(Icons.attach_money),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
