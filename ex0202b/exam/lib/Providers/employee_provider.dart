import 'dart:async';

import 'package:exam/Models/patient.dart';
import 'package:exam/Models/record.dart';
import 'package:exam/Repos/employee_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmployeeProvider extends ChangeNotifier {
  EmployeeRepo repo = EmployeeRepo();
  bool isOnline = true;
  bool modified = true;

  Future<List<Patient>> getPatients() async {
    return repo.getPatients();
  }

  void changeModified() {
    modified = true;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<String> deletePatient(Patient patient) async {
    String response = await repo.deletePatient(patient);
    notifyListeners();
    return response;
  }

  Future<String> addRecord(Record record) {
    return repo.addRecord(record);
  }
}
