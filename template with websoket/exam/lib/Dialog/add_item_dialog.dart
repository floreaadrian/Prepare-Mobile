import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> addItemDialog({
  BuildContext context,
}) async {
  final _textKey = GlobalKey<FormState>();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add item"),
          content: Form(
            key: _textKey,
            child: SingleChildScrollView(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      decoration: new InputDecoration(labelText: 'Details'),
                      controller: _detailsController,
                      textInputAction: Platform.isAndroid
                          ? TextInputAction.next
                          : TextInputAction.continueAction),
                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Status'),
                    controller: _statusController,
                    textInputAction: Platform.isAndroid
                        ? TextInputAction.next
                        : TextInputAction.continueAction,
                  ),
                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Age'),
                    controller: _ageController,
                    textInputAction: Platform.isAndroid
                        ? TextInputAction.next
                        : TextInputAction.continueAction,
                  ),
                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Type'),
                    controller: _typeController,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Add"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int userId = prefs.getInt("user");
                Map<String, dynamic> inputData = {
                  "id": -1,
                  "details": _detailsController.text,
                  "age": int.parse(_ageController.text),
                  "status": _statusController.text,
                  "type": _typeController.text,
                  "user": userId,
                };
                Navigator.of(context).pop(inputData);
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
