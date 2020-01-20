import 'package:exam/Models/game.dart';
import 'package:exam/Providers/client_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSimpleWidget extends StatelessWidget {
  final Game game;
  const GameSimpleWidget({Key key, @required this.game}) : super(key: key);

  Widget loanBike(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.directions_bike),
      onPressed: () async {
        final provider = Provider.of<ClientProvider>(context, listen: false);
        // String result = await provider.loanBike(bike);
        // if (result == "") {
        //   showSnack(context, result);
        //   await asyncDetailsDialog(context, bike);
        // } else {
        //   showSnack(context, result);
        // }
      },
    );
  }

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
