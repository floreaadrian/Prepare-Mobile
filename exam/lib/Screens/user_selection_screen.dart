import 'package:connectivity/connectivity.dart';
import 'package:exam/Providers/user_provider.dart';
import 'package:exam/Widgets/bike_simple_widget.dart';
import 'package:exam/Widgets/custom_snack.dart';
import 'package:exam/Widgets/our_drawer.dart';
import 'package:exam/Widgets/retun_dialog.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

class UserSelectionScreen extends StatefulWidget {
  UserSelectionScreen({Key key}) : super(key: key);

  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  ProgressDialog pr;
  var subscription;
  @override
  void initState() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        provider.changeInternetStatus(false);
      } else {
        provider.changeInternetStatus(true);
      }
    });
  }

  Widget getAvalible(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: true);
    return FutureBuilder(
        future: provider.getAvalibleBikes(),
        builder: (context, bikesSnap) {
          if (bikesSnap.connectionState == ConnectionState.done) {
            if (bikesSnap.data == null) return Container();
            return ListView.builder(
              itemCount: bikesSnap.data.length,
              itemBuilder: (context, index) {
                return BikeSimpleWidget(
                  forUser: true,
                  bike: bikesSnap.data[index],
                  pr: pr,
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("User selection"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.data_usage),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                HISTORY_SCREEN,
              );
            },
          ),
          provider.isOnline
              ? IconButton(
                  icon: Icon(Icons.delete_sweep),
                  onPressed: () async {
                    int id = await asyncReturnDialog(context);
                    pr.style(message: "Waiting to return");
                    pr.show();
                    String result = await provider.returnBike(id);
                    await pr.hide();
                  },
                )
              : Container(),
        ],
      ),
      drawer: OurDrawer(),
      body: provider.isOnline
          ? Container(
              child: getAvalible(context),
            )
          : Center(
              child: Text("You are offline"),
            ),
    );
  }
}
