import 'package:exam/Models/record.dart';
import 'package:flutter/material.dart';

Future<void> asyncDetailsDialog(BuildContext context, Record record) async {
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
            Text("Id: " + record.id.toString()),
            Text("Name: " + record.name),
            Text("Patient id: " + record.patientId.toString()),
            Text("Type: " + record.type),
            Text("Status: " + record.status),
            Text("Date: " + DateTime.utc(record.date).toString())
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
