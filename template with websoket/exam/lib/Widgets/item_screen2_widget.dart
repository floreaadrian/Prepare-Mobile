import 'package:exam/Dialog/string_dialog.dart';
import 'package:exam/Models/item.dart';
import 'package:exam/Providers/screen2_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemScreen2Widget extends StatefulWidget {
  final Item item;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ItemScreen2Widget({
    Key key,
    @required this.item,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _ItemScreen2WidgetState createState() => _ItemScreen2WidgetState();
}

class _ItemScreen2WidgetState extends State<ItemScreen2Widget> {
  Widget changeStatus(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.change_history),
      onPressed: () async {
        final provider = Provider.of<Screen2Provider>(context, listen: false);
        String newStatus = await stringItemDialog(context, "Status");
        if (newStatus != null && newStatus != "") {
          String response =
              await provider.changeStatus(widget.item.id, newStatus);
          var snackbar = new SnackBar(content: new Text(response));
          widget.scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
  }

  // Widget deleteItem(BuildContext context) {
  //   return IconButton(
  //     icon: Icon(Icons.delete),
  //     onPressed: () async {
  //       final provider = Provider.of<Screen2Provider>(context, listen: false);
  //       String response = await provider.deleteName(widget.name);
  //       var snackbar = new SnackBar(content: new Text(response));
  //       widget.scaffoldKey.currentState.showSnackBar(snackbar);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.deepPurpleAccent[150],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Id: " + widget.item.id.toString(),
                    style: TextStyle(fontSize: 20)),
                Text("Details: " + widget.item.details,
                    style: TextStyle(fontSize: 20)),
                Text("Status: " + widget.item.status,
                    style: TextStyle(fontSize: 20)),
                Text("User: " + widget.item.user.toString(),
                    style: TextStyle(fontSize: 20)),
                Text("Age: " + widget.item.age.toString(),
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          changeStatus(context),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
