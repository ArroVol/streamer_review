import 'package:flutter/material.dart';
import 'package:streamer_review/favorite_card.dart';
import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';

class FavoritesContainer extends StatefulWidget {
  @override
  _FavoritesContainer createState() => _FavoritesContainer();
}

class _FavoritesContainer extends State<FavoritesContainer> {
  List<FavoriteCard> favList = [];
  List<Streamer> listOfFavs = [];

  @override
  Widget build(BuildContext context) {
    getStreamerList();
    return Container(
      height: 1000,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: favList,
      ),
    );
  }

  Future<List<FavoriteCard>> getStreamerList() async {
    List<FavoriteCard> streamerList = new List<FavoriteCard>();
    // listOfFavs =  getFavStreamers();
    // getFavStreamers();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    var getStreamerList = await d.getFavorites();
    // print("got streamer list from db");


    if (getStreamerList != null) {
      for (int i = 0; i < getStreamerList.length; i++) {
        temp = getStreamerList[i]["fk_broadcaster_id"];
        FavoriteCard favCard = new FavoriteCard(temp.toString());
        streamerList.add(favCard);
      }
    }
    if (streamerList != null) {
      setState(() {
        favList = streamerList;
      });
    }
    return streamerList;
  }

  var temp;
  List<String> idList = new List<String>();

  // void getFavStreamers() async {
  //   DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
  //   var getStreamerList = await d.getFavorites();
  //   if (getStreamerList != null) {
  //     for (int i = 0; i < getStreamerList.length; i++) {
  //       temp = getStreamerList[i]["fk_broadcaster_id"];
  //       print("Temp: " +
  //           temp.toString() +
  //           "-------------------------------------------------------------------------------------------------------------------");
  //       idList.add(temp.toString());
  //     }
  //   }
  // }

  @override
  void initState() {
    getStreamerList();
    super.initState();
  }
}
