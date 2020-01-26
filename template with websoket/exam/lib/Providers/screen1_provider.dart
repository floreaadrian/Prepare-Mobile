import 'dart:async';
import 'package:exam/Models/item.dart';
import 'package:exam/Repository/db_rep.dart';
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
  DBRep dbRep = DBRep();

  Future<List<Item>> getItems() async {
    // if (localItems.length > 0 && !modified) return localItems;
    if (isOnline)
      localItems = await rep.getAll();
    else
      localItems = await dbRep.getAllItems();
    return localItems;
  }

  void changeModified() {
    modified = true;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<int> getUserId() async {
    return dbRep.getId();
  }

  Future<String> addItem(Item item) async {
    String added = await rep.addItemNoMetterWhat(item);
    notifyListeners();
    return added;
  }

  void refresh() {
    fromServer = true;
    notifyListeners();
  }
}
