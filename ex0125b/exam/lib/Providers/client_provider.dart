import 'dart:async';

import 'package:exam/Models/game.dart';
import 'package:exam/Repository/client_repository.dart';
import 'package:exam/Repository/db_client_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final String beginLog = "ClientProvider ";

class ClientProvider extends ChangeNotifier {
  ClientRepository repo = ClientRepository();
  DbClientRepo dbRepo = DbClientRepo();
  bool isOnline = false;
  bool modified = true;
  List<Game> locGame = [];

  Future<List<Game>> getAvalible() async {
    if (locGame.length > 0 && !modified) return locGame;
    if (isOnline) locGame = await repo.getAvalible();
    modified = false;
    return locGame;
  }

  void changeModified() {
    modified = true;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<dynamic> buyGame(int id, int quantity) async {
    dynamic response = await repo.buyGame(id, quantity);
    modified = true;
    notifyListeners();
    return response;
  }

  Future<dynamic> rentGame(int id) async {
    dynamic response = await repo.rentGame(id);
    modified = true;
    notifyListeners();
    return response;
  }

  Future<void> addBuyGame(Game result) {
    return dbRepo.buy(result);
  }

  Future<List<Game>> boughtGames() {
    return dbRepo.boughtGames();
  }

  Future<List<Game>> rentedGames() {
    return dbRepo.rentedGames();
  }

  Future<void> addRentGame(Game result) {
    return dbRepo.rent(result);
  }

  void addGameLocally(Game game) {
    locGame.add(game);
    notifyListeners();
  }
}
