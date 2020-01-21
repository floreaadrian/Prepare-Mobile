import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/game.dart';
import 'package:exam/Providers/employee_provider.dart';
import 'package:exam/Widgets/drawer.dart';
import 'package:exam/Widgets/game_simple_widget_em.dart';
import 'package:exam/dialogs/custom_snack.dart';
import 'package:exam/dialogs/game_dialog.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class EmployeeScreen extends StatefulWidget {
  EmployeeScreen({Key key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  var channel;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  var subscription;

  @override
  void initState() {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    super.initState();
    if (provider.isOnline) {
      channel = IOWebSocketChannel.connect("ws://10.0.2.2:4001")
        ..stream.listen((message) {
          provider.addGameLocally(Game.fromJson(jsonDecode(message)));
        });
    }

    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        if (channel is IOWebSocketChannel) channel.sink.close();
        provider.changeInternetStatus(false);
      } else {
        channel = IOWebSocketChannel.connect("ws://10.0.2.2:4001")
          ..stream.listen((message) {
            provider.addGameLocally(Game.fromJson(jsonDecode(message)));
          });
        provider.changeInternetStatus(true);
      }
    });
  }

  Widget getAvalible(
      BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
    final provider = Provider.of<EmployeeProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getAvalible(),
      builder: (context, gamesSnap) {
        if (gamesSnap.connectionState == ConnectionState.done) {
          if (gamesSnap.data == null) return Container();
          return ListView.builder(
            itemCount: gamesSnap.data.length,
            itemBuilder: (context, index) {
              return GameSimpleWidgetEm(
                game: gamesSnap.data[index],
                scaffoldKey: _scaffoldKey,
                pr: pr,
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Employee screen"),
        actions: <Widget>[],
      ),
      drawer: OurDrawer(),
      body: provider.isOnline
          ? getAvalible(context, _scaffoldKey)
          : Center(
              child: Text("You are offline"),
            ),
      floatingActionButton: provider.isOnline
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                final provider =
                    Provider.of<EmployeeProvider>(context, listen: false);
                Map<String, dynamic> res =
                    await addGameDialog(context: context);
                dynamic response = await provider.addGame(Game.fromJson(res));
                if (response is Game) {
                  provider.addGameLocally(response);
                } else {
                  showSnack(context, response);
                }
              },
            )
          : null,
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    if (channel is IOWebSocketChannel) channel.sink.close();
    super.dispose();
  }
}
