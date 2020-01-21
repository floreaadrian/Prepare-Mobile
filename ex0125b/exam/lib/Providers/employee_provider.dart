import 'dart:async';

import 'package:exam/Models/game.dart';
import 'package:exam/Repository/employee_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final String beginLog = "EmployeeProvider ";

class EmployeeProvider extends ChangeNotifier {
  EmployeeRepository repo = EmployeeRepository();
  bool isOnline = false;
  bool modified = true;
  List<Game> locGame = [];

  Future<List<Game>> getAvalible() async {
    if (locGame.length > 0 && !modified) return locGame;
    if (isOnline) locGame = await repo.getAll();
    modified = false;
    return locGame;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<dynamic> addGame(Game game) {
    dynamic response = repo.addGame(game);
    return response;
  }

  void addGameLocally(Game response) {
    locGame.add(response);
    notifyListeners();
  }

  Future<String> deleteGame(Game game) async {
    String response = await repo.deleteGame(game.id);
    await new Future.delayed(Duration(seconds: 1));
    if (response == "") {
      locGame.remove(game);
      notifyListeners();
    }
    return response;
  }

  Future<String> update(Game game) async {
    String response = await repo.updateGame(game);
    if (response == "") {
      modified = true;
      notifyListeners();
    }
    return response;
  }
}
