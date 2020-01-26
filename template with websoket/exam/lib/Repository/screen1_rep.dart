import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/item.dart';
import 'package:exam/Repository/db_rep.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen1Rep {
  List<Item> list = new List();
  var logger = Logger();
  List<Item> localList = new List();
  String baseUrl = "http://10.0.2.2:2302/"; //TODO: CHANGE PORT
  Map<String, String> headers = {"Content-type": "application/json"};
  int userId;
  DBRep dbRep = DBRep();

  Future<bool> checkIfHaveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("user");
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Item>> getAll() async {
    var rng = new Random();
    logger.i("Server: Getting all items");
    bool isInternetAvailable = await isConnectedToInternet();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("user")) {
      prefs.setInt("user", rng.nextInt(100));
    }
    userId = prefs.getInt("user");
    if (localList.length > 0) {
      await addEvery();
    }
    if (isInternetAvailable) {
      Response response = await get(baseUrl + 'orders/$userId');
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Item> list = List();
        dbRep.deleteAllItems();
        for (var elem in body) {
          final item = Item.fromJson(elem);
          dbRep.addItem(item);
          list.add(item);
        }
        return list;
      } else {
        logger.e("Server: Error in getting items");
        return [];
      }
    } else {
      return dbRep.getAllItems();
    }
  }

  Future<dynamic> addItem(Item item) async {
    logger.i("Server: adding item to server");
    Response response = await post(
      baseUrl + 'order',
      headers: headers,
      body: json.encode(item.toJson()),
    );
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Item itemNew = new Item.fromJson(body);
      //dbRep.addItem(itemNew);
      logger.i("Server: added item to server");
      return itemNew;
    } else {
      String error = json.decode(response.body)["text"];
      logger.e("Server: error on adding $error");
      return error;
    }
  }

  Future<String> addEvery() async {
    var errors = "";
    for (var i in localList) {
      dynamic result = await addItem(i);
      if (result is String) errors += result;
    }
    localList.clear();
    return errors;
  }

  Future<String> addItemNoMetterWhat(Item item) async {
    bool isInternetAvailable = await isConnectedToInternet();
    localList.add(item);
    if (isInternetAvailable) {
      return addEvery();
    } else {
      dbRep.addItem(item);
      return "";
    }
  }

  Future<String> updateItem(Item oldItem, Item newItem) async {
    logger.i("Rep: Updating Item");
    list.remove(oldItem);
    list.add(newItem); //TODO: error here too
    return "yoink";
  }
}
