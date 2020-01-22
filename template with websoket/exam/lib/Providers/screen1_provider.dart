import 'dart:async';
import 'package:exam/Models/item.dart';
import 'package:exam/Repository/screen1_rep.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Screen1Provider extends ChangeNotifier {
  var logger = Logger();
  Screen1Rep rep = Screen1Rep();
  bool isOnline = true;
  bool modified = true;
  bool fromServer = true;
  List<Item> localItems = [];

  Future<List<Item>> getItems() async {
    if (localItems.length > 0 && !modified) return localItems;
    if (isOnline) localItems = await rep.getAll();
    return localItems;
  }

  void changeModified() {
    modified = true;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<String> deleteItem(Item item) async {
    String response = await rep.deleteItem(item);
    //notifyListeners();
    return response;
  }

  Future<dynamic> addItem(Item item) async {
    dynamic added = await rep.addItem(item);
    //notifyListeners();
    return added;
  }

  void refresh() {
    fromServer = true;
    notifyListeners();
  }

  Future<void> deleteItemLocal(Item item) async {
    localItems.remove(item);
    modified = false;
    notifyListeners();
  }

  Future<void> addItemLocal(Item item) async {
    localItems.add(item);
    modified = false;
    notifyListeners();
  }
}
