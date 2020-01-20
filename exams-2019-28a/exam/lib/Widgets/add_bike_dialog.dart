import 'dart:io';

import 'package:flutter/material.dart';

Future<Map<String, String>> addBikeDialog({
  BuildContext context,
}) async {
  final _textKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _ownerController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add bike"),
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
                          labelText: 'Owner', hintText: "oner"),
                      controller: _ownerController,
                      textInputAction: Platform.isAndroid
                          ? TextInputAction.next
                          : TextInputAction.continueAction),
                  TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Size', hintText: "ceva"),
                    controller: _sizeController,
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
              child: new Text("Add bike"),
              onPressed: () {
                Map<String, String> inputData = {
                  "name": _nameController.text,
                  "type": _typeController.text,
                  "owner": _ownerController.text,
                  "status": _statusController.text,
                  "size": _sizeController.text
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
