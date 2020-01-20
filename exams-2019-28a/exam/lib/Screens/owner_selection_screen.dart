import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/bike.dart';
import 'package:exam/Providers/owner_provider.dart';
import 'package:exam/Widgets/add_bike_dialog.dart';
import 'package:exam/Widgets/bike_simple_widget.dart';
import 'package:exam/Widgets/our_drawer.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class OwnerSelectionScreen extends StatefulWidget {
  const OwnerSelectionScreen({Key key}) : super(key: key);

  @override
  _OwnerSelectionScreenState createState() => _OwnerSelectionScreenState();
}

class _OwnerSelectionScreenState extends State<OwnerSelectionScreen> {
  ProgressDialog pr;
  var subscription;
  @override
  void initState() {
    final provider = Provider.of<OwnerProvider>(context, listen: false);
    super.initState();
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
    final provider = Provider.of<OwnerProvider>(context, listen: true);
    return FutureBuilder(
        future: provider.getAll(),
        builder: (context, bikesSnap) {
          if (bikesSnap.connectionState == ConnectionState.done) {
            if (bikesSnap.data == null) return Container();
            return ListView.builder(
              itemCount: bikesSnap.data.length,
              itemBuilder: (context, index) {
                return BikeSimpleWidget(
                  forUser: false,
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
    final provider = Provider.of<OwnerProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Owner selection"),
      ),
      drawer: OurDrawer(),
      body: provider.isOnline
          ? Container(
              child: provider.loading == true
                  ? CircularProgressIndicator()
                  : getAvalible(context),
            )
          : Container(
              child: Center(
                child: Text("You are offline"),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Map<String, String> data = await addBikeDialog(context: context);
          provider.makeWait();
          await provider.addBike(Bike.fromJson(data));
          provider.notWait();
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
