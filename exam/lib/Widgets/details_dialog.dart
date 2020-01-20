import 'package:exam/Models/bike.dart';
import 'package:flutter/material.dart';

Future<void> asyncDetailsDialog(BuildContext context, Bike bike) async {
  return showDialog<void>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Bike datails'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Name: " + bike.name),
            Text("Type: " + bike.type),
            Text("Size: " + bike.size),
            Text("Owner: " + bike.owner),
            Text("Status: " + bike.status),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
