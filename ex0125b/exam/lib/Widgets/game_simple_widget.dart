import 'package:exam/Models/game.dart';

import 'package:flutter/material.dart';

class GameSimpleWidget extends StatelessWidget {
  final Game game;
  const GameSimpleWidget({Key key, @required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.yellow[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Name: " + game.name),
              Text("Quantity: " + game.quantity.toString()),
              Text("Type: " + game.type),
            ],
          ),
        ],
      ),
    );
  }
}
