import 'package:exam/Providers/client_provider.dart';
import 'package:exam/Widgets/drawer.dart';
import 'package:exam/Widgets/game_simple_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RentedGamesScreen extends StatefulWidget {
  RentedGamesScreen({Key key}) : super(key: key);

  @override
  _RentedGamesScreenState createState() => _RentedGamesScreenState();
}

class _RentedGamesScreenState extends State<RentedGamesScreen> {
  Widget getAvalible(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.rentedGames(),
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
        title: Text("Rented games"),
      ),
      body: Container(
        child: getAvalible(context),
      ),
    );
  }
}
