// Open the database and store the reference.
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const bikesTable = 'bikes';
  static const String id = 'id';
  static const String name = 'name';
  static const String type = 'type';
  static const String size = 'size';
  static const String owner = 'owner';
  static const String status = 'status';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult]) {
    print(functionName);
    print(sql);
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createPassangerTable(Database db) async {
    final passangerSql = '''CREATE TABLE $bikesTable
    (
        $id INTEGER PRIMARY KEY,
        $name VARCHAR(60),
        $type VARCHAR(60),
        $size VARCHAR(60),
        $owner VARCHAR(60),
        $status VARCHAR(60)
    )''';
    await db.execute(passangerSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    if (await Directory(dirname(path)).exists()) {
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }

    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('passanger_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createPassangerTable(db);
  }
}
