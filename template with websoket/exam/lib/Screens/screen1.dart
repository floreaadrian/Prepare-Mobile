import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Dialog/add_item_dialog.dart';
import 'package:exam/Models/item.dart';
import 'package:exam/Providers/screen1_provider.dart';
import 'package:exam/Providers/screen2_provider.dart';
import 'package:exam/Widgets/item_screen1_widget.dart';
import 'package:exam/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class Screen1 extends StatefulWidget {
  Screen1({Key key}) : super(key: key);

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  var connectivity;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var wbsoket;
  @override
  void initState() {
    final provider = Provider.of<Screen1Provider>(context, listen: false);
    final provider2 = Provider.of<Screen2Provider>(context, listen: false);
    super.initState();
    if (provider.isOnline)
      try {
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
      } catch (e) {}
    connectivity = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        if (wbsoket is IOWebSocketChannel) wbsoket.sink.close();
        provider.changeInternetStatus(false);
        provider2.changeInternetStatus(false);
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
        provider2.changeInternetStatus(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Screen1Provider>(context, listen: true);
    return Scaffold(
      drawer: OurDrawer(),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Client section"),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              provider.refresh();
            },
            child: Icon(Icons.refresh),
            color: Theme.of(context).primaryColor,
          ),
          RaisedButton(
            onPressed: () async {
              final data = await addItemDialog(context: context);
              if (data != null) {
                String result = await provider.addItem(Item.fromJson(data));
                if (result != "") {
                  _scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: new Text(result)));
                }
              }
            },
            child: Icon(Icons.add),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
      body: itemList(context),
    );
  }

  Widget itemList(BuildContext context) {
    final provider = Provider.of<Screen1Provider>(context, listen: true);
    // if (!provider.isOnline) {
    //   var snackbar = new SnackBar(content: new Text("You are offline"));
    //   _scaffoldKey.currentState.showSnackBar(snackbar);
    // }
    return FutureBuilder(
      future: provider.getItems(),
      builder: (context, itemsSnap) {
        if (itemsSnap.connectionState == ConnectionState.done) {
          if (itemsSnap.data == null) return Container();
          return ListView.builder(
            itemCount: itemsSnap.data.length,
            itemBuilder: (context, index) {
              return ItemScreen1Widget(
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
