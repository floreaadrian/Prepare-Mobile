import 'dart:convert';

import 'package:exam/Models/patient.dart';
import 'package:exam/Models/record.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class EmployeeRepo {
  final String baseUrl = 'http://10.0.2.2:4022/';
  final Map<String, String> headers = {"Content-type": "application/json"};

  Future<List<Patient>> getPatients() async {
    logger.i("entered");
    List<Patient> toReturn = [];
    Response response = await get(baseUrl + "all");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      toReturn = body.map((f) => Patient.fromJson(f)).toList();
    }
    logger.i("exit with: " + toReturn.map((f) => f.toJson()).toString());
    return toReturn;
  }

  Future<String> deletePatient(Patient patient) async {
    logger.i("entered with id:${patient.id}");
    Response response =
        await delete(baseUrl + "patient/" + patient.id.toString());
    if (response.statusCode == 200) {
      return "Succesfull";
    } else
      return jsonDecode(response.body)["text"];
  }

  Future<String> addRecord(Record record) async {
    logger.i("entered with record: " + record.toJson().toString());
    Response response = await post(
      baseUrl + "add",
      headers: {"Content-type": "application/json"},
      body: jsonEncode(record.toJson()),
    );
    if (response.statusCode == 200) {
      logger.i("exited succesfuly with" + response.body);
      return "Succes";
    }
    logger.e("exited error with ${response.body}");
    return jsonDecode(response.body)["text"];
  }
}
