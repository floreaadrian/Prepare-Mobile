import 'package:flutter/material.dart';

void showSnack(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    duration: Duration(seconds: 1),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}
