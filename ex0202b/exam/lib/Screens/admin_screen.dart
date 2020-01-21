import 'package:connectivity/connectivity.dart';
import 'package:exam/Widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AdminScreen extends StatefulWidget {
  AdminScreen({Key key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool isOnline;
  var subscription;

  var _scaffoldKeyE = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    isOnline = true;
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOnline = false;
        });
      } else {
        setState(() {
          isOnline = true;
        });
      }
    });
  }

  void nuke(BuildContext context) async {
    logger.i('Entered nuke');
    Response response = await delete('http://10.0.2.2:4022/nuke');
    _scaffoldKeyE.currentState.showSnackBar(
      SnackBar(
        content: Text("Boom"),
      ),
    );
    logger.i('exited nuke');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyE,
      drawer: OurDrawer(),
      appBar: AppBar(
        title: Text('Admin screen'),
      ),
      body: Container(
        child: isOnline
            ? Center(
                child: GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () => nuke(context),
                ),
              )
            : Center(child: Text("You are offline!")),
      ),
    );
  }
}
