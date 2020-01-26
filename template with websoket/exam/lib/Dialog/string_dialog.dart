import 'package:flutter/material.dart';

Future<String> stringItemDialog(BuildContext context, String title) async {
  final _textKey = GlobalKey<FormState>();
  String nr;
  return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Specify " + title),
          content: Form(
            key: _textKey,
            child: SingleChildScrollView(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: new InputDecoration(labelText: title),
                    onChanged: (val) => nr = val,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(nr);
              },
            ),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
