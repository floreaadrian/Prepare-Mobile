import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/item.dart';
import 'package:exam/Models/user.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class Screen2Rep {
  List<String> list = new List();
  var logger = Logger();
  List<String> localList = new List();
  String baseUrl = "http://10.0.2.2:2302/"; //TODO: CHANGE PORT
  Map<String, String> headers = {"Content-type": "application/json"};

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Item>> getAllItems() async {
    logger.i("Rep: Retrieving all items");
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      // print(baseUrl);
      Response response = await get(baseUrl + 'pending');
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Item> list = List();
        // print(body);
        //dbRep.deleteAllItems();
        for (var elem in body) {
          final item = Item.fromJson(elem);
          //dbRep.addItem(item);
          list.add(item);
        }
        return list;
      } else {
        logger.e("Server: Error in getting items");
        return [];
      }
    } else {
      //return dbRep.getAllItems();
      return List();
    }
  }

  Future<String> changeStatus(int id, String newStatus) async {
    logger.i("Server: changing status");
    Response response = await post(
      baseUrl + 'status',
      headers: headers,
      body: json.encode(
        {
          "id": id.toString(),
          "status": newStatus,
        },
      ),
    );
    if (response.statusCode == 200) {
      //dbRep.addItem(itemNew);
      logger.i("Server: added item to server");
      return "Succes";
    } else {
      String error = json.decode(response.body)["text"];
      logger.e("Server: error on adding $error");
      return error;
    }
  }

  Future<List<User>> getAllUsers() async {
    logger.i("Rep: Retrieving all users");
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      Response response = await get(baseUrl + 'all');
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<User> list = [];
        Map<int, int> users = new Map<int, int>();
        for (var elem in body) {
          if (users.containsKey(elem["user"])) {
            users[elem["user"]]++;
          } else {
            users[elem["user"]] = 1;
          }
        }
        for (var key in users.keys) {
          list.add(User(id: key, orders: users[key]));
        }
        list.sort((a, b) => b.orders.compareTo(a.orders));
        return list;
      } else {
        logger.e("Server: Error in getting users");
        return [];
      }
    } else {
      //return dbRep.getAllItems();
      return List();
    }
  }
}
