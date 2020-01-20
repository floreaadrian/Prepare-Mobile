import 'package:exam/Models/game.dart';

import '../database_creator.dart';

class DbClientRepo {
  Future<List<Game>> boughtGames() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.gamesTable}''';
    final data = await db.rawQuery(sql);
    List<Game> passangers = List();
    for (var node in data) {
      if (node["rented"] == 0) {
        final passanger = Game.fromJson(node);
        passangers.add(passanger);
      }
    }
    return passangers;
  }

  Future<void> buy(Game game) async {
    final sql = '''INSERT INTO ${DatabaseCreator.gamesTable}
    (
      ${DatabaseCreator.name},
      ${DatabaseCreator.quantity},
      ${DatabaseCreator.status},
      ${DatabaseCreator.type},
      ${DatabaseCreator.rented}
    )
    VALUES
    (
      "${game.name}",
      ${game.quantity},
      "${game.status}",
      "${game.type}",
      0
    )
    ''';
    final result = await db.rawInsert(sql);
    DatabaseCreator.databaseLog('Add game to bought', sql, null, result);
    return;
  }

  Future<List<Game>> rentedGames() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.gamesTable}''';
    final data = await db.rawQuery(sql);
    List<Game> passangers = List();
    for (var node in data) {
      if (node["rented"] == 1) {
        final passanger = Game.fromJson(node);
        passangers.add(passanger);
      }
    }
    return passangers;
  }

  Future<void> rent(Game game) async {
    final sql = '''INSERT INTO ${DatabaseCreator.gamesTable}
    (
      ${DatabaseCreator.name},
      ${DatabaseCreator.quantity},
      ${DatabaseCreator.status},
      ${DatabaseCreator.type},
      ${DatabaseCreator.rented}
    )
    VALUES
    (
      "${game.name}",
      ${game.quantity},
      "${game.status}",
      "${game.type}",
      1
    )
    ''';
    final result = await db.rawInsert(sql);
    DatabaseCreator.databaseLog('Add game to rented', sql, null, result);
    return;
  }
}
