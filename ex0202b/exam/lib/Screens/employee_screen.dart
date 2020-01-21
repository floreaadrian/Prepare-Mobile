import 'package:connectivity/connectivity.dart';
import 'package:exam/Dialogs/record_input_dialog.dart';
import 'package:exam/Models/record.dart';
import 'package:exam/Providers/employee_provider.dart';
import 'package:exam/Providers/patient_provider.dart';
import 'package:exam/Widgets/drawer.dart';
import 'package:exam/Widgets/patien_widget_em.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class EmployeeScreen extends StatefulWidget {
  EmployeeScreen({Key key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  ProgressDialog pr;
  var _scaffoldKeyE = new GlobalKey<ScaffoldState>();
  var subscription;

  @override
  void initState() {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    provider.changeModified();
    super.initState();
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
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
    final provider = Provider.of<EmployeeProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getPatients(),
      builder: (context, patientsSnap) {
        if (patientsSnap.connectionState == ConnectionState.done) {
          if (patientsSnap.data == null) return Container();
          return ListView.builder(
            itemCount: patientsSnap.data.length,
            itemBuilder: (context, index) {
              return PatientWidgetEm(
                patient: patientsSnap.data[index],
                scaffoldKey: _scaffoldKeyE,
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
      key: _scaffoldKeyE,
      drawer: OurDrawer(),
      appBar: AppBar(
        title: Text('Employee screen'),
        actions: <Widget>[
          // rentWidget(context),
        ],
      ),
      body: Container(
        child: provider.isOnline
            ? getAvalible(context)
            : Center(child: Text("You are offline!")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add record",
        onPressed: () async {
          Map<String, dynamic> inputData = await addRecordDialog(
            context: context,
          );
          pr.style(message: "adding record");
          pr.show();
          String response =
              await provider.addRecord(Record.fromJson(inputData));
          while (pr.isShowing()) await pr.hide();
          var snackbar = new SnackBar(content: new Text(response));
          _scaffoldKeyE.currentState.showSnackBar(snackbar);
        },
      ),
    );
  }
}
