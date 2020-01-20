import 'package:exam/Providers/user_provider.dart';
import 'package:exam/Widgets/bike_details.dart';
import 'package:exam/Widgets/our_drawer.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  ProgressDialog pr;
  var subscription;
  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
  }

  Widget getAvalible(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: true);
    return FutureBuilder(
        future: provider.getHistory(),
        builder: (context, bikesSnap) {
          if (bikesSnap.connectionState == ConnectionState.done) {
            if (bikesSnap.data == null) return Container();
            return ListView.builder(
              itemCount: bikesSnap.data.length,
              itemBuilder: (context, index) {
                return BikeDetailed(
                  bike: bikesSnap.data[index],
                  pr: pr,
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User history of loaned"),
      ),
      drawer: OurDrawer(),
      body: Container(
        child: getAvalible(context),
      ),
    );
  }
}
