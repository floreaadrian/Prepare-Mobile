import 'package:exam/Models/patient.dart';
import 'package:exam/Providers/patient_provider.dart';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

class PatientWidget extends StatefulWidget {
  final Patient patient;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool local;

  const PatientWidget({
    Key key,
    @required this.patient,
    @required this.scaffoldKey,
    @required this.local,
  }) : super(key: key);

  @override
  _PatientWidgetState createState() => _PatientWidgetState();
}

class _PatientWidgetState extends State<PatientWidget> {
  Widget addPatientToLocal(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        final provider = Provider.of<PatientProvider>(context, listen: false);
        String response = await provider.addToLocal(widget.patient);
        var snackbar = new SnackBar(content: new Text(response));
        widget.scaffoldKey.currentState.showSnackBar(snackbar);
      },
    );
  }

  Widget deletePatient(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        final provider = Provider.of<PatientProvider>(context, listen: false);
        String response = await provider.deletePatientLocal(widget.patient);
        var snackbar = new SnackBar(content: new Text(response));
        widget.scaffoldKey.currentState.showSnackBar(snackbar);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.yellow[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RECORDS_SCREEN,
                arguments: widget.patient.id,
              );
            },
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Name: " + widget.patient.name),
              ],
            ),
          ),
          widget.local ? deletePatient(context) : addPatientToLocal(context),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
