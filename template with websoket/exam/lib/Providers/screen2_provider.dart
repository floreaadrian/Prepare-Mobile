import 'dart:async';
import 'package:exam/Models/user.dart';
import 'package:exam/Repository/screen2_rep.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../Models/item.dart';

class Screen2Provider extends ChangeNotifier {
  var logger = Logger();
  Screen2Rep rep = Screen2Rep();
  bool isOnline = true;
  bool modified = true;
  bool fromServer = true;
  List<Item> localItems = [];

  Future<List<Item>> getItems() async {
    logger.i("Provider: Retreiving...");
    if (localItems.length > 0 && !modified) return localItems;
    if (isOnline) localItems = await rep.getAllItems();
    return localItems;
  }

  void changeModified() {
    modified = true;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  void refresh() {
    fromServer = true;
    notifyListeners();
  }

  Future<String> changeStatus(int id, String newStatus) async {
    String response = await rep.changeStatus(id, newStatus);
    notifyListeners();
    return response;
  }

  Future<List<User>> getAllUsers() {
    return rep.getAllUsers();
  }
}
