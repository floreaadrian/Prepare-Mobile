import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Dialog/add_item_dialog.dart';
import 'package:exam/Models/item.dart';
import 'package:exam/Providers/screen1_provider.dart';
import 'package:exam/Providers/screen2_provider.dart';
import 'package:exam/Widgets/item_screen2_widget.dart';
import 'package:exam/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class Screen2 extends StatefulWidget {
  Screen2({Key key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var connectivity;
  var wbsoket;

  @override
  void initState() {
    final provider = Provider.of<Screen2Provider>(context, listen: false);
    final provider1 = Provider.of<Screen1Provider>(context, listen: false);
    super.initState();
    if (provider.isOnline)
      wbsoket =
          IOWebSocketChannel.connect("ws://10.0.2.2:2302") //TODO:CHANGE PORT
            ..stream.listen((message) {
              var item = Item.fromJson(jsonDecode(message));
              var snackbar = new SnackBar(
                  content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Id: " + item.id.toString()),
                  Text("Details: " + item.details),
                  Text("Status: " + item.status),
                  Text("User: " + item.user.toString()),
                  Text("Age: " + item.age.toString()),
                ],
              ));
              _scaffoldKey.currentState.showSnackBar(snackbar);
            });
    connectivity = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        if (wbsoket is IOWebSocketChannel) wbsoket.sink.close();
        provider.changeInternetStatus(false);
        provider1.changeInternetStatus(false);
      } else {
        wbsoket =
            IOWebSocketChannel.connect("ws://10.0.2.2:2302") //TODO:CHANGE PORT
              ..stream.listen((message) {
                var item = Item.fromJson(jsonDecode(message));
                var snackbar = new SnackBar(
                    content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Id: " + item.id.toString()),
                    Text("Details: " + item.details),
                    Text("Status: " + item.status),
                    Text("User: " + item.user.toString()),
                    Text("Age: " + item.age.toString()),
                  ],
                ));
                _scaffoldKey.currentState.showSnackBar(snackbar);
              });
        provider.changeInternetStatus(true);
        provider1.changeInternetStatus(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Screen2Provider>(context, listen: true);
    return Scaffold(
      drawer: OurDrawer(),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Store section"),
      ),
      body: provider.isOnline
          ? itemList(context)
          : Center(
              child: Text("You are offline"),
            ),
    );
  }

  Widget itemList(BuildContext context) {
    final provider = Provider.of<Screen2Provider>(context, listen: true);
    return FutureBuilder(
      future: provider.getItems(),
      builder: (context, itemsSnap) {
        if (itemsSnap.connectionState == ConnectionState.done) {
          if (itemsSnap.data == null) return Container();
          return ListView.builder(
            itemCount: itemsSnap.data.length,
            itemBuilder: (context, index) {
              return ItemScreen2Widget(
                item: itemsSnap.data[index],
                scaffoldKey: _scaffoldKey,
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
  void dispose() {
    if (wbsoket is IOWebSocketChannel) wbsoket.sink.close();
    connectivity.cancel();
    super.dispose();
  }
}
