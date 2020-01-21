import 'dart:convert';

import 'package:exam/Models/patient.dart';
import 'package:exam/Models/record.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class PatientRepo {
  final String baseUrl = 'http://10.0.2.2:4022/';
  final Map<String, String> headers = {"Content-type": "application/json"};

  Future<List<Patient>> getPatients() async {
    logger.i("entered");
    List<Patient> toReturn = [];
    Response response = await get(baseUrl + "patients");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      toReturn = body.map((f) => Patient.fromJson(f)).toList();
    }
    logger.i("exit with: " + toReturn.map((f) => f.toJson()).toString());
    return toReturn;
  }

  Future<dynamic> getRecords(int patientId) async {
    logger.i("entered with id:$patientId");
    List<Record> toReturn = [];
    Response response = await get(baseUrl + "records/" + patientId.toString());
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      toReturn = body.map((f) => Record.fromJson(f)).toList();
    } else {
      return jsonDecode(response.body)["text"];
    }
    logger.i("exit with: " + toReturn.map((f) => f.toJson()).toString());
    return toReturn;
  }

  Future<dynamic> getDetails(int id) async {
    logger.i("entered with id:$id");
    Response response = await get(baseUrl + "details/" + id.toString());
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      return Record.fromJson(body);
    } else {
      return jsonDecode(response.body)["text"];
    }
  }
}
