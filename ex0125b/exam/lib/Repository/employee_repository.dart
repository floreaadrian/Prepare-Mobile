import 'dart:convert';

import 'package:exam/Models/game.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class EmployeeRepository {
  final String baseUrl = 'http://10.0.2.2:4001/';
  final Map<String, String> headers = {"Content-type": "application/json"};

  Future<List<Game>> getAll() async {
    logger.i("entered");
    List<Game> toReturn = [];
    Response response = await get(baseUrl + "all");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      toReturn = body.map((f) => Game.fromJson(f)).toList();
    }
    logger.i("exit with: " + toReturn.map((f) => f.toJson()).toString());
    return toReturn;
  }

  Future<dynamic> addGame(Game game) async {
    logger.i("entered with game: " + game.toJson().toString());
    Response response = await post(
      baseUrl + "addGame",
      headers: {"Content-type": "application/json"},
      body: jsonEncode(game.toJson()),
    );
    if (response.statusCode == 200) {
      logger.i("exited succesfuly with" + response.body);
      return Game.fromJson(
        jsonDecode(response.body),
      );
    }
    logger.e("exited error with ${response.body}");
    return jsonDecode(response.body)["text"];
  }

  Future<String> deleteGame(int id) async {
    logger.i("entered with id:$id");
    Response response = await post(
      baseUrl + "removeGame",
      body: {
        "id": id.toString(),
      },
    );
    if (response.statusCode == 200) {
      logger.i("exited succesfuly with " + response.body);
      return "";
    }
    logger.e("exited error with ${response.body}");
    return jsonDecode(response.body)["text"];
  }

  Future<String> updateGame(Game game) async {
    return "";
  }
}
