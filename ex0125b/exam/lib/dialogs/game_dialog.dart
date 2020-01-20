import 'dart:io';

import 'package:flutter/material.dart';

Future<Map<String, dynamic>> addGameDialog({
  BuildContext context,
}) async {
  final _textKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add game"),
          content: Form(
            key: _textKey,
            child: SingleChildScrollView(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: TextFormField(
                        autofocus: true,
                        controller: _nameController,
                        decoration: new InputDecoration(labelText: 'Name'),
                        textInputAction: Platform.isAndroid
                            ? TextInputAction.next
                            : TextInputAction.continueAction),
                  ),
                  TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'Type', hintText: "ok"),
                      controller: _typeController,
                      textInputAction: Platform.isAndroid
                          ? TextInputAction.next
                          : TextInputAction.continueAction),
                  TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Quantity', hintText: "3"),
                    controller: _quantityController,
                    textInputAction: Platform.isAndroid
                        ? TextInputAction.next
                        : TextInputAction.continueAction,
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Status', hintText: "avalible"),
                    controller: _statusController,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Add game"),
              onPressed: () {
                Map<String, dynamic> inputData = {
                  "name": _nameController.text,
                  "type": _typeController.text,
                  "quantity": int.parse(_quantityController.text),
                  "status": _statusController.text,
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
