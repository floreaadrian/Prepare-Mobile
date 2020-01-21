// Open the database and store the reference.
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;
var logger = Logger();

class DatabaseCreator {
  static const String patientsTable = 'patients';
  static const String recordsTable = 'records';
  static const String id = 'id';
  static const String patientId = 'patientId';
  static const String name = 'name';
  static const String type = 'type';
  static const String status = 'status';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult]) {
    String toLog = "";
    toLog += functionName + sql;
    if (selectQueryResult != null) {
      toLog += selectQueryResult.toString();
    } else if (insertAndUpdateQueryResult != null) {
      toLog += insertAndUpdateQueryResult.toString();
    }
    logger.i(toLog);
  }

  Future<void> createPaitentsTable(Database db) async {
    final passangerSql = '''CREATE TABLE $patientsTable
    (
        $id INTEGER PRIMARY KEY,
        $name VARCHAR(60)
    )''';
    await db.execute(passangerSql);
  }

  Future<void> createRecordsTable(Database db) async {
    final passangerSql = '''CREATE TABLE $recordsTable
    (
        $id INTEGER PRIMARY KEY,
        $patientId INTEGER ,
        $type VARCHAR(60),
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
    final path = await getDatabasePath('game_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createRecordsTable(db);
    await createPaitentsTable(db);
  }
}
