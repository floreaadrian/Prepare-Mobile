import 'package:flutter/material.dart';

Future<int> asyncReturnIdDialog(BuildContext context) async {
  int id = 0;
  return showDialog<int>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter the game id and the quantity'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Id of the game', hintText: '3'),
              onChanged: (value) {
                id = int.parse(value);
              },
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop(id);
            },
          ),
        ],
      );
    },
  );
}
