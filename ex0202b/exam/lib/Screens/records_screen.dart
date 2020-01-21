import 'package:connectivity/connectivity.dart';
import 'package:exam/Providers/patient_provider.dart';
import 'package:exam/Widgets/drawer.dart';
import 'package:exam/Widgets/record_widget.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class RecordsScreen extends StatefulWidget {
  final int id;
  RecordsScreen({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  ProgressDialog pr;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var subscription;

  @override
  void initState() {
    final provider = Provider.of<PatientProvider>(context, listen: false);
    provider.changeModified();
    super.initState();

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
    final provider = Provider.of<PatientProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getRecords(widget.id),
      builder: (context, patientsSnap) {
        if (patientsSnap.connectionState == ConnectionState.done) {
          if (patientsSnap.data is String) return Text("Error");
          if (patientsSnap.data == null) return Container();
          return ListView.builder(
            itemCount: patientsSnap.data.length,
            itemBuilder: (context, index) {
              return RecordWidget(
                record: patientsSnap.data[index],
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: OurDrawer(),
      appBar: AppBar(
        title: Text('Record screen'),
        actions: <Widget>[
          // rentWidget(context),
        ],
      ),
      body: Container(
        child: getAvalible(context),
      ),
    );
  }
}
