import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

Database db;

class DBCreator {
  static const itemTable = 'itemTable';
  static const subTable = 'subTable';
  static const id = 'id';
  static const String details = 'details';
  static const String status = 'status';
  static const String user = 'user';
  static const String age = 'age';
  static const String type = 'type';

  Future<void> createItemTable(Database db) async {
    final createSql = '''CREATE TABLE $itemTable 
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $details VARCHAR(64),
      $status VARCHAR(128),
      $user INTEGER,
      $age INTEGER,
      $type VARCHAR(128)
    )''';
    await db.execute(createSql);
  }

  Future<void> creteIdTable(Database db) async {
    final createSql = '''CREATE TABLE $subTable 
    (
      $user INTEGER PRIMARY KEY AUTOINCREMENT,
    )''';
    await db.execute(createSql);
  }

  Future<String> getDBPath(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    if (await Directory(dirname(path)).exists()) {
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDB() async {
    final path = await getDBPath('phone_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createItemTable(db);
    await creteIdTable(db);
  }
}
