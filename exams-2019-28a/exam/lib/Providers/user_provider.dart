import 'dart:async';

import 'package:exam/Controllers/user_controller.dart';
import 'package:exam/Models/bike.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final String beginLog = "UserProvider ";

class UserProvider extends ChangeNotifier {
  UserController userController = new UserController();
  bool isOnline = true;

  Future<List<Bike>> getAvalibleBikes() async {
    print(beginLog + 'getAvalibleBikes - entered');
    List<Bike> toReturn = await userController.getAvalibleBikes();
    print(beginLog + 'getAvalibleBikes - exit');
    return toReturn;
  }

  Future<String> loanBike(Bike bike) async {
    print(beginLog + 'loanBike - entered with bike: ${bike.toJson()}');
    String result = await userController.loanBike(bike);
    print(beginLog + 'loanBike - exit');
    notifyListeners();
    return result;
  }

  Future<String> returnBike(int id) async {
    print(beginLog + 'returnBike - entered with id: $id');
    String result = await userController.returnBike(id);
    print(beginLog + 'returnBike - exit');
    return result;
  }

  Future<List<Bike>> getHistory() async {
    print(beginLog + 'getHistory - entered');
    List<Bike> toReturn = await userController.historyLoaned();
    print(beginLog + 'getHistory - exit');
    return toReturn;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }
}
