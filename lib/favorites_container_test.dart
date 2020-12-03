import 'package:flutter/material.dart';
import 'package:streamer_review/favorite_card.dart';
import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';

class FavoritesContainer2 extends StatefulWidget {
  List<String> listOfFavoritesID;

  FavoritesContainer2(List<String> streamerList) {
    this.listOfFavoritesID = streamerList;
  }

  @override
  _FavoritesContainer2 createState() => _FavoritesContainer2(listOfFavoritesID);
}

class _FavoritesContainer2 extends State<FavoritesContainer2> {
  List<String> streamerList;

  _FavoritesContainer2(List<String> streamerList) {
    this.streamerList = streamerList;
  }

  List<FavoriteCard> favList = [];


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

  var temp;


  Future<List<FavoriteCard>> getStreamerList() async {
    List<FavoriteCard> streamerList1 = new List<FavoriteCard>();
    // print("getting favorite cards in fav container 2=====================================================");
    // print(streamerList.length.toString() + "))))))))))))))))))))))))))))))))))))))))))))))))))))))))");
    if (streamerList != null) {
      for (int i = 0; i < streamerList.length; i++) {
        // print("container 2: streamerId: "+ temp.toString()+ " +=============================================");
        temp = streamerList[i];
        FavoriteCard favCard = new FavoriteCard(temp.toString());
        streamerList1.add(favCard);
      }
    }
    if (streamerList != null) {
      setState(() {
        favList = streamerList1;
      });
    }
    // print(favList.length);
    return streamerList1;
  }


  @override
  void initState() {
    getStreamerList();
    super.initState();
  }
}
