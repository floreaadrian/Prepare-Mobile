import 'dart:convert';

import 'package:exam/Models/game.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class ClientRepository {
  final String baseUrl = 'http://10.0.2.2:4001/';
  final Map<String, String> headers = {"Content-type": "application/json"};

  Future<List<Game>> getAvalible() async {
    logger.i("entered");
    List<Game> toReturn = [];
    Response response = await get(baseUrl + "games");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      toReturn = body.map((f) => Game.fromJson(f)).toList();
    }
    logger.i("exit with: " + toReturn.map((f) => f.toJson()).toString());
    return toReturn;
  }

  Future<dynamic> buyGame(int id, int quantity) async {
    logger.i("entered with id:$id and quantity $quantity");
    Response response = await post(
      baseUrl + "buyGame",
      body: jsonEncode({
        "quantity": quantity.toString(),
        "id": id.toString(),
      }),
      headers: headers,
    );
    if (response.statusCode == 200) {
      logger.i("exited succesful with response.body");
      return Game.fromJson(jsonDecode(response.body));
    }
    logger.e("exited error with ${response.body}");
    return jsonDecode(response.body)["text"];
  }

  Future<dynamic> rentGame(int id) async {
    logger.i("entered with id:$id");
    Response response = await post(
      baseUrl + "rentGame",
      body: jsonEncode({
        "id": id.toString(),
      }),
      headers: headers,
    );
    if (response.statusCode == 200) {
      logger.i("exited succesful with ${response.body}");
      return Game.fromJson(jsonDecode(response.body));
    }
    logger.e("exited error with ${response.body}");
    return jsonDecode(response.body)["text"];
  }
}
