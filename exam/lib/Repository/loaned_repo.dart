import 'package:exam/Models/bike.dart';

import '../database_creator.dart';

class LoanedRepo {
  List<Bike> loaned = [];

  Future<List<Bike>> history() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.bikesTable}''';
    final data = await db.rawQuery(sql);
    List<Bike> passangers = List();
    for (var node in data) {
      final passanger = Bike.fromJson(node);
      passangers.add(passanger);
    }
    return passangers;
  }

  Future<void> add(Bike bike) async {
    final sql = '''INSERT INTO ${DatabaseCreator.bikesTable}
    (
      ${DatabaseCreator.name},
      ${DatabaseCreator.owner},
      ${DatabaseCreator.size},
      ${DatabaseCreator.status},
      ${DatabaseCreator.type}
    )
    VALUES
    (
      "${bike.name}",
      "${bike.owner}",
      "${bike.size}",
      "${bike.status}",
      "${bike.type}"
    )
    ''';
    final result = await db.rawInsert(sql);
    DatabaseCreator.databaseLog('Add bike to loaned', sql, null, result);
    return;
  }
}
