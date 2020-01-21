import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/game.dart';
import 'package:exam/Providers/client_provider.dart';
import 'package:exam/Widgets/drawer.dart';
import 'package:exam/Widgets/game_simple_widget.dart';
import 'package:exam/dialogs/id_dialog.dart';
import 'package:exam/dialogs/id_quantity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../routes.dart';

class ClientScreen extends StatefulWidget {
  ClientScreen({Key key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  var channel;
  ProgressDialog pr;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var subscription;
  @override
  void initState() {
    final provider = Provider.of<ClientProvider>(context, listen: false);
    provider.changeModified();
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

  Widget getAvalible(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getAvalible(),
      builder: (context, gamesSnap) {
        if (gamesSnap.connectionState == ConnectionState.done) {
          if (gamesSnap.data == null) return Container();
          return ListView.builder(
            itemCount: gamesSnap.data.length,
            itemBuilder: (context, index) {
              return GameSimpleWidget(
                game: gamesSnap.data[index],
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

  void buyGame(BuildContext context) async {
    final provider = Provider.of<ClientProvider>(context, listen: true);
    if (provider.isOnline) {
      List<int> ok = await asyncReturnIdQuantityDialog(context);
      pr.style(message: "Game is being bought");
      pr.show();
      dynamic result = await provider.buyGame(ok[0], ok[1]);
      await pr.hide();
      if (result is Game) {
        await provider.addBuyGame(result);
        Navigator.pushReplacementNamed(context, OWN_GAMES_SCREEN);
      } else {
        var snackbar = new SnackBar(content: new Text(result));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
    } else {
      var snackbar = new SnackBar(content: new Text('Offline'));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  Widget rentWidget(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context, listen: true);
    return IconButton(
      icon: Icon(Icons.hourglass_empty),
      onPressed: () async {
        if (provider.isOnline) {
          int id = await asyncReturnIdDialog(context);
          pr.style(message: "Game is being rented");
          pr.show();
          dynamic result = await provider.rentGame(id);
          await pr.hide();
          if (result is Game) {
            await provider.addRentGame(result);
            Navigator.pushReplacementNamed(context, RENT_GAMES_SCREEN);
          } else {
            var snackbar = new SnackBar(content: new Text(result));
            _scaffoldKey.currentState.showSnackBar(snackbar);
          }
        } else {
          var snackbar = new SnackBar(content: new Text('Offline'));
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      drawer: OurDrawer(),
      appBar: AppBar(
        title: Text('Client screen'),
        actions: <Widget>[
          rentWidget(context),
        ],
      ),
      body: Container(
        child: provider.isOnline
            ? getAvalible(context)
            : Center(child: Text("You are offline!")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.monetization_on),
        onPressed: () => buyGame(context),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    if (channel is IOWebSocketChannel) channel.sink.close();
    super.dispose();
  }
}
