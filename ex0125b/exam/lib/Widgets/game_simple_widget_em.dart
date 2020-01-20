import 'package:exam/Models/game.dart';
import 'package:exam/Providers/client_provider.dart';
import 'package:exam/Providers/employee_provider.dart';
import 'package:exam/dialogs/custom_snack.dart';
import 'package:exam/dialogs/update_game_dialog.dart';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class GameSimpleWidgetEm extends StatefulWidget {
  final Game game;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ProgressDialog pr;

  const GameSimpleWidgetEm({
    Key key,
    @required this.game,
    @required this.scaffoldKey,
    @required this.pr,
  }) : super(key: key);

  @override
  _GameSimpleWidgetEmState createState() => _GameSimpleWidgetEmState();
}

class _GameSimpleWidgetEmState extends State<GameSimpleWidgetEm> {
  Widget deleteGame(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        final provider = Provider.of<EmployeeProvider>(context, listen: false);
        widget.pr.style(message: "Delete game");
        widget.pr.show();
        String result = await provider.deleteGame(widget.game);
        await widget.pr.hide();
        if (result == "") {
          var snackbar = new SnackBar(content: new Text("Delete succesful"));
          widget.scaffoldKey.currentState.showSnackBar(snackbar);
        } else {
          var snackbar = new SnackBar(content: new Text(result));
          widget.scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
  }

  Widget updateGame(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.update),
      onPressed: () async {
        final provider = Provider.of<EmployeeProvider>(context, listen: false);
        Map<String, dynamic> input =
            await updateGameDialog(context: context, game: widget.game);
        widget.pr.style(message: "Update game");
        widget.pr.show();
        await widget.pr.hide();
        String result = await provider.update(Game.fromJson(input));
        if (result == "") {
          var snackbar = new SnackBar(content: new Text("Update succesful"));
          widget.scaffoldKey.currentState.showSnackBar(snackbar);
        } else {
          var snackbar = new SnackBar(content: new Text(result));
          widget.scaffoldKey.currentState.showSnackBar(snackbar);
        }
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
              Text("Name: " + widget.game.name),
              Text("Quantity: " + widget.game.quantity.toString()),
              Text("Type: " + widget.game.type),
              Text("Status: " + widget.game.status),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              deleteGame(context),
              updateGame(context),
            ],
          )
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
