import 'package:exam/Models/patient.dart';
import 'package:exam/Providers/employee_provider.dart';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class PatientWidgetEm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ProgressDialog pr;

  const PatientWidgetEm(
      {Key key,
      @required this.patient,
      @required this.scaffoldKey,
      @required this.pr})
      : super(key: key);

  @override
  _PatientWidgetEmState createState() => _PatientWidgetEmState();
}

class _PatientWidgetEmState extends State<PatientWidgetEm> {
  Widget deletePatient(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        final provider = Provider.of<EmployeeProvider>(context, listen: false);
        widget.pr.style(message: "Deleting patient");
        widget.pr.show();
        String response = await provider.deletePatient(widget.patient);

        while (widget.pr.isShowing()) await widget.pr.hide();
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
          Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Name: " + widget.patient.name),
              Text("Id: " + widget.patient.id.toString()),
            ],
          ),
          deletePatient(context),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    if (widget.pr.isShowing()) await widget.pr.hide();
    super.dispose();
  }
}
