import 'package:exam/Models/item.dart';
import 'package:exam/Providers/screen1_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemScreen1Widget extends StatefulWidget {
  final Item item;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ItemScreen1Widget({
    Key key,
    @required this.item,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _ItemScreen1WidgetState createState() => _ItemScreen1WidgetState();
}

class _ItemScreen1WidgetState extends State<ItemScreen1Widget> {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Id: " + widget.item.id.toString(),
                    style: TextStyle(fontSize: 20)),
                Text("Details: " + widget.item.details,
                    style: TextStyle(fontSize: 20)),
                Text("Status: " + widget.item.status,
                    style: TextStyle(fontSize: 20)),
                Text("Age: " + widget.item.age.toString(),
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
