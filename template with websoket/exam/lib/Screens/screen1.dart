import 'package:connectivity/connectivity.dart';
import 'package:exam/Dialog/add_item_dialog.dart';
import 'package:exam/Models/item.dart';
import 'package:exam/Providers/screen1_provider.dart';
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
    super.initState();
    // if (provider.isOnline)
    //   wbsoket =
    //       IOWebSocketChannel.connect("ws://10.0.2.2:4001") //TODO:CHANGE PORT
    //         ..stream.listen((message) {
    //           // provider.addGameLocally(Game.fromJson(jsonDecode(message)));
    //         });
    connectivity = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        if (wbsoket is IOWebSocketChannel) wbsoket.sink.close();
        provider.changeInternetStatus(false);
      } else {
        // wbsoket =
        // IOWebSocketChannel.connect("ws://10.0.2.2:4001") //TODO:CHANGE PORT
        //   ..stream.listen((message) {
        //     // provider.addGameLocally(Game.fromJson(jsonDecode(message)));
        //   });
        provider.changeInternetStatus(true);
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
        title: Text("Screen1"),
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
              if (provider.isOnline) {
                final data = await addItemDialog(context: context);
                if (data != null) {
                  dynamic result = await provider.addItem(Item.fromJson(data));
                  if (result is String) {
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: new Text(result)));
                  }
                }
              } else {
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: new Text("No internet connection")));
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
