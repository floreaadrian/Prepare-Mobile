import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Providers/patient_provider.dart';
import 'package:exam/Widgets/drawer.dart';
import 'package:exam/Widgets/patient_widget.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class LocalPatientScreen extends StatefulWidget {
  LocalPatientScreen({Key key}) : super(key: key);

  @override
  _LocalPatientScreenState createState() => _LocalPatientScreenState();
}

class _LocalPatientScreenState extends State<LocalPatientScreen> {
  ProgressDialog pr;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var subscription;

  @override
  void initState() {
    final provider = Provider.of<PatientProvider>(context, listen: false);
    provider.changeModified();
    super.initState();
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
        provider.changeInternetStatus(false);
      } else {
        provider.changeInternetStatus(true);
      }
    });
  }

  Widget getAvalible(BuildContext context) {
    final provider = Provider.of<PatientProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getSavedPations(),
      builder: (context, patientsSnap) {
        if (patientsSnap.connectionState == ConnectionState.done) {
          if (patientsSnap.data == null) return Container();
          return ListView.builder(
            itemCount: patientsSnap.data.length,
            itemBuilder: (context, index) {
              return PatientWidget(
                patient: patientsSnap.data[index],
                scaffoldKey: _scaffoldKey,
                local: true,
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
      drawer: OurDrawer(),
      appBar: AppBar(
        title: Text('Patient associetion screen'),
        actions: <Widget>[
          // rentWidget(context),
        ],
      ),
      body: Container(child: getAvalible(context)),
    );
  }
}
