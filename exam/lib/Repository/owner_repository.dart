import 'dart:convert';

import 'package:exam/Models/bike.dart';
import 'package:http/http.dart';

class OwnerRepository {
  final String baseUrl = "http://localhost:2028/";

  Future<List<Bike>> getAll() async {
    List<Bike> toReturn = [];
    Response response = await get(baseUrl + "all");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      toReturn = body.map((f) => Bike.fromJson(f)).toList();
    }
    return toReturn;
  }

  Future<Bike> addBike(Bike bike) async {
    Response response = await post(
      baseUrl + "bike",
      headers: {"Content-type": "application/json"},
      body: jsonEncode(bike.toJson()),
    );
    if (response.statusCode == 200) {
      return Bike.fromJson(
        jsonDecode(response.body),
      );
    }
    return null;
  }

  Future<String> deleteBike(int id) async {
    Response response = await delete(
      baseUrl + "bike/" + id.toString(),
    );
    if (response.statusCode == 200) {
      return "";
    }
    return jsonDecode(response.body)["text"];
  }
}
