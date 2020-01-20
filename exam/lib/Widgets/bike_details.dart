import 'package:exam/Models/bike.dart';
import 'package:exam/Providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'custom_snack.dart';

class BikeDetailed extends StatelessWidget {
  final Bike bike;
  final ProgressDialog pr;

  const BikeDetailed({Key key, this.bike, this.pr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.yellow[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Name: " + bike.name),
              Text("Type: " + bike.type),
              Text("Size: " + bike.size),
              Text("Owner: " + bike.owner),
              Text("Status: " + bike.status),
            ],
          ),
          IconButton(
            icon: Icon(Icons.assignment_return),
            onPressed: () async {
              final provider =
                  Provider.of<UserProvider>(context, listen: false);
              pr.style(
                message: 'Waiting to return',
              );
              pr.show();
              String result = await provider.returnBike(bike.id);
              pr.hide();
              showSnack(context, result == "" ? "Returning succesful" : result);
            },
          )
        ],
      ),
    );
  }
}
