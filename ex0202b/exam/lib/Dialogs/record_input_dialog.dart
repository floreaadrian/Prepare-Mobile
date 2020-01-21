import 'dart:io';

import 'package:flutter/material.dart';

Future<Map<String, dynamic>> addRecordDialog({
  BuildContext context,
}) async {
  final _textKey = GlobalKey<FormState>();
  TextEditingController _patientIdController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add record"),
          content: Form(
            key: _textKey,
            child: SingleChildScrollView(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: TextFormField(
                        autofocus: true,
                        controller: _patientIdController,
                        decoration: new InputDecoration(labelText: 'PatientId'),
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
                        labelText: 'Details', hintText: "Cevava"),
                    controller: _detailsController,
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
              child: new Text("Add record"),
              onPressed: () {
                Map<String, dynamic> inputData = {
                  "patientId": int.parse(_patientIdController.text),
                  "type": _typeController.text,
                  "_detailsController": _detailsController.text,
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
