import 'package:exam/Providers/client_provider.dart';
import 'package:exam/Widgets/drawer.dart';
import 'package:exam/Widgets/game_simple_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwnGamesScreen extends StatefulWidget {
  OwnGamesScreen({Key key}) : super(key: key);

  @override
  _OwnGamesScreenState createState() => _OwnGamesScreenState();
}

class _OwnGamesScreenState extends State<OwnGamesScreen> {
  Widget getAvalible(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.boughtGames(),
      builder: (context, gamesSnap) {
        if (gamesSnap.connectionState == ConnectionState.done) {
          if (gamesSnap.data == null) return Container();
          return ListView.builder(
            itemCount: gamesSnap.data.length,
            itemBuilder: (context, index) {
              return GameSimpleWidget(
                game: gamesSnap.data[index],
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
      drawer: OurDrawer(),
      appBar: AppBar(
        title: Text("Bought games"),
      ),
      body: Container(
        child: getAvalible(context),
      ),
    );
  }
}
