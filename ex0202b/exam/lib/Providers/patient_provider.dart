import 'dart:async';

import 'package:exam/Models/patient.dart';
import 'package:exam/Models/record.dart';
import 'package:exam/Repos/patient_db_repo.dart';
import 'package:exam/Repos/patient_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PatientProvider extends ChangeNotifier {
  PatientRepo repo = PatientRepo();
  DbPatientRepo dbRepo = DbPatientRepo();
  bool isOnline = false;
  bool modified = true;

  Future<List<Patient>> getPatients() async {
    return repo.getPatients();
  }

  Future<dynamic> getRecords(int patientId) async {
    if (isOnline) {
      dynamic response = await repo.getRecords(patientId);
      if (!(response is String)) {
        await dbRepo.addRecords(response);
      }
      return response;
    } else
      return dbRepo.getRecords(patientId);
  }

  void changeModified() {
    modified = true;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<String> addToLocal(Patient patient) async {
    return dbRepo.addPatient(patient);
  }

  Future<String> deletePatientLocal(Patient patient) async {
    String response = await dbRepo.deletePatient(patient);
    notifyListeners();
    return response;
  }

  Future<List<Patient>> getSavedPations() async {
    return dbRepo.getPatients();
  }

  Future<String> addRecords(List<Record> records) {
    return dbRepo.addRecords(records);
  }

  Future<dynamic> getDetails(int id) {
    return repo.getDetails(id);
  }
}
