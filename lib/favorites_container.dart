import 'package:flutter/material.dart';
import 'package:streamer_review/favorite_card.dart';
import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';

/// Creates the favorites container state.
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
      height: 500,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: favList,
      ),
    );
  }
  /// Gets a list of streamers.
  Future<List<FavoriteCard>> getStreamerList() async {
    List<FavoriteCard> streamerList = new List<FavoriteCard>();
    // listOfFavs =  getFavStreamers();
    // getFavStreamers();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    var getStreamerList = await d.getFavorites();
    // print("got streamer list from db");


    if (getStreamerList != null) {
      // print(getStreamerList.length);
      for (int i = 0; i < getStreamerList.length; i++) {
        temp = getStreamerList[i]["fk_broadcaster_id"];
        // print("Temp: " +
        //     temp.toString() +
        //     "-------------------------------------------------------------------------------------------------------------------");
        FavoriteCard favCard = new FavoriteCard(temp.toString());
        // print(
        //     "new card was supposedly made?----------------------------------------------------------------------------------");
        streamerList.add(favCard);
      }
    }
    if (streamerList != null) {
      if (mounted) {
        setState(() {
          favList = streamerList;
        });
      }
    }
    // print('HERE');
    print(favList.length);
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
