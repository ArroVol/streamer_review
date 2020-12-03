import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'favorite_card.dart';
import 'favorites_container.dart';
import 'package:streamer_review/favorite_card.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'favorites_container_test.dart';
import 'helper/database_helper.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPage createState() => new _FavoritesPage();
}


class _FavoritesPage extends State<FavoritesPage> {
  List<String> favoritesList = [];
  var temp;

  Future<List<String>> getStreamerList() async {
    favoritesList.clear();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    var getStreamerList = await d.getFavorites();

    if (getStreamerList != null) {
      for (int i = 0; i < getStreamerList.length; i++) {
        temp = getStreamerList[i]["fk_broadcaster_id"].toString();
        print("broadcaster id: "+ temp+ " *****************************************************************");
        favoritesList.add(temp);
      }
    }
    print("favoritelist.length in get data: "+ favoritesList.length.toString()+ "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{");

    return favoritesList;
  }



  @override
  void initState() {
    getStreamerList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // getStreamerList();
    print("favoritelist.length: "+ favoritesList.length.toString()+ "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{");
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple[900], Colors.white],
              stops: [0.2, 1],
            )),
        child: Container(
          child: FavoritesContainer2(favoritesList),
            // ],
          ),
        ),
    );
  }
}
