import 'package:exam/Dialogs/show_dialog.dart';
import 'package:exam/Models/patient.dart';
import 'package:exam/Models/record.dart';
import 'package:exam/Providers/patient_provider.dart';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

class RecordWidget extends StatefulWidget {
  final Record record;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const RecordWidget({
    Key key,
    @required this.record,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _RecordWidgetState createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
      showLogs: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.yellow[300],
      child: GestureDetector(
          onTap: () async {
            final provider =
                Provider.of<PatientProvider>(context, listen: false);
            if (provider.isOnline) {
              // pr.style(message: "Waiting for details");
              // pr.show();
              dynamic response = await provider.getDetails(widget.record.id);
              // await closeIt();
              if (response is Record) {
                await asyncDetailsDialog(context, response);
              } else {
                var snackbar = new SnackBar(content: new Text(response));
                widget.scaffoldKey.currentState.showSnackBar(snackbar);
              }
            }
          },
          child: ListTile(
            title: Text("Type: " + widget.record.type),
            subtitle: Text("Status: " + widget.record.status),
          )),
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
