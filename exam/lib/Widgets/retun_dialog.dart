import 'package:flutter/material.dart';

Future<int> asyncReturnDialog(BuildContext context) async {
  int toReturn = 0;
  return showDialog<int>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter the bike id'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Id of the bije', hintText: '3'),
              onChanged: (value) {
                toReturn = int.parse(value);
              },
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(toReturn);
            },
          ),
        ],
      );
    },
  );
}
