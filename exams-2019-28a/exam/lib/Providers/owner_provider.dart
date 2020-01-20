import 'dart:async';

import 'package:exam/Controllers/owner_controller.dart';
import 'package:exam/Models/bike.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final String beginLog = "OwnerProvider ";

class OwnerProvider extends ChangeNotifier {
  OwnerController ownerController = new OwnerController();
  bool isOnline = true;
  bool loading = false;

  Future<List<Bike>> getAll() async {
    print(beginLog + 'getAll - entered');
    List<Bike> bikes = await ownerController.getAll();
    print(beginLog + 'getAll - exit');
    return bikes;
  }

  Future<Bike> addBike(Bike bike) async {
    print(beginLog + 'addBike - entered');
    Bike newBike = await ownerController.addBike(bike);
    print(beginLog + 'addBike - exit');
    return newBike;
  }

  Future<String> deleteBike(
    Bike bike,
  ) async {
    print(beginLog + 'deleteBike - entered');
    String toReturn = await ownerController.deleteBike(bike);
    print(beginLog + 'deleteBike - exit');
    return toReturn;
  }

  void makeWait() {
    loading = true;
    notifyListeners();
  }

  void notWait() {
    loading = false;
    notifyListeners();
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }
}
