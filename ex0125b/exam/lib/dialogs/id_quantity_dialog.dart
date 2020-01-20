import 'package:flutter/material.dart';

Future<List<int>> asyncReturnIdQuantityDialog(BuildContext context) async {
  int id = 0;
  int quantity = 0;
  return showDialog<List<int>>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter the game id and the quantity'),
        content: Column(
          children: <Widget>[
            new Row(
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
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  autofocus: true,
                  decoration:
                      new InputDecoration(labelText: 'Quantity', hintText: '3'),
                  onChanged: (value) {
                    quantity = int.parse(value);
                  },
                ))
              ],
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop([id, quantity]);
            },
          ),
        ],
      );
    },
  );
}
