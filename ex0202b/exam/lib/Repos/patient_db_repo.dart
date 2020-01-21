import 'package:exam/Models/patient.dart';
import 'package:exam/Models/record.dart';

import '../database_creator.dart';

class DbPatientRepo {
  Future<List<Patient>> getPatients() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.patientsTable}''';
    final data = await db.rawQuery(sql);
    List<Patient> passangers = List();
    for (var node in data) {
      final passanger = Patient.fromJson(node);
      passangers.add(passanger);
    }
    return passangers;
  }

  Future<String> addPatient(Patient patient) async {
    final sql = '''INSERT INTO ${DatabaseCreator.patientsTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.name}
    )
    VALUES
    (
      ${patient.id},
      "${patient.name}"
    )
    ''';
    try {
      final result = await db.rawInsert(sql);
      DatabaseCreator.databaseLog('Add patient to db', sql, null, result);
    } catch (e) {
      return "Error";
    }
    return "Succes";
  }

  Future<String> deletePatient(Patient patient) async {
    final sql = '''DELETE FROM ${DatabaseCreator.patientsTable}
    WHERE ${DatabaseCreator.id} = ${patient.id}
    ''';
    try {
      final result = await db.rawDelete(sql);
      DatabaseCreator.databaseLog('Add patient to db', sql, null, result);
    } catch (e) {
      return "Error";
    }
    return "Succes";
  }

  Future<List<Record>> getRecords(int patientId) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.recordsTable} 
        WHERE ${DatabaseCreator.patientId} = $patientId''';
    final data = await db.rawQuery(sql);
    List<Record> passangers = List();
    for (var node in data) {
      final passanger = Record.fromJson(node);
      passangers.add(passanger);
    }
    return passangers;
  }

  Future<String> addRecords(List<Record> records) async {
    records.forEach((f) async {
      var sql = '''INSERT INTO ${DatabaseCreator.recordsTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.patientId},
      ${DatabaseCreator.type},
      ${DatabaseCreator.status}
    )
    VALUES
    (
      ${f.id},
      ${f.patientId},
      "${f.type}",
      "${f.status}"
    )
    ''';
      try {
        final result = await db.rawInsert(sql);
        DatabaseCreator.databaseLog('Add record to db', sql, null, result);
      } catch (e) {
        logger.e(e);
      }
    });
    return "";
  }
}
