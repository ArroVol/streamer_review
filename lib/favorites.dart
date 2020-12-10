import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'favorites_container.dart';
import 'package:streamer_review/favorites_container.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
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
        favoritesList.add(temp);
      }
    }
    return favoritesList;
  }

  @override
  void initState() {
    getStreamerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'STREVIEW',
          style: TextStyle(color: Colors.lightGreenAccent, letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: Container(
        child: Container(
          child: FavoritesContainer(),
          // ],
        ),
      ),
    );
  }
}
