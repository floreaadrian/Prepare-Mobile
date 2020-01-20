import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:exam/Models/bike.dart';
import 'package:exam/Providers/owner_provider.dart';
import 'package:exam/Providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'custom_snack.dart';
import 'details_dialog.dart';

class BikeSimpleWidget extends StatelessWidget {
  final bool forUser;
  final Bike bike;
  final ProgressDialog pr;
  const BikeSimpleWidget({Key key, this.forUser, this.bike, this.pr})
      : super(key: key);

  Widget loanBike(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.directions_bike),
      onPressed: () async {
        final provider = Provider.of<UserProvider>(context, listen: false);
        String result = await provider.loanBike(bike);
        if (result == "") {
          showSnack(context, result);
          await asyncDetailsDialog(context, bike);
        } else {
          showSnack(context, result);
        }
      },
    );
  }

  Widget deleteBike(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        final provider = Provider.of<OwnerProvider>(context, listen: false);
        provider.makeWait();
        provider.deleteBike(bike).then((result) async {
          if (result == "") {
            showSnack(context, "Deleted good");
          } else {
            showSnack(context, result);
          }
          provider.notWait();
        });
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
              Text("Name: " + bike.name),
              Text("Type: " + bike.type),
              Text("Size: " + bike.size),
              forUser ? Container() : Text("Status: " + bike.status)
            ],
          ),
          forUser ? loanBike(context) : deleteBike(context),
        ],
      ),
    );
  }
}
