import 'dart:convert';

import 'package:exam/Models/bike.dart';
import 'package:http/http.dart';

class UserOnlineRepo {
  final String baseUrl = "http://localhost:2028/";

  Future<List<Bike>> getAvalibleBikes() async {
    List<Bike> toReturn = [];
    Response response = await get(baseUrl + "bikes");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      toReturn = body.map((f) => Bike.fromJson(f)).toList();
    }
    return toReturn;
  }

  Future<String> loanBike(int id) async {
    Response response = await post(
      baseUrl + "loan",
      body: {
        "id": id.toString(),
      },
    );
    if (response.statusCode == 200) {
      return "";
    }
    return jsonDecode(response.body)["text"];
  }

  Future<String> returnBike(int id) async {
    Response response = await post(
      baseUrl + "return",
      body: {
        "id": id.toString(),
      },
    );
    if (response.statusCode == 200) {
      return "";
    }
    return null;
  }
}
