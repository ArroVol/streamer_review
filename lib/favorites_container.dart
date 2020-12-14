import 'package:flutter/material.dart';
import 'package:streamer_review/favorite_card.dart';
import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


/// Creates the favorites container state.
class FavoritesContainer extends StatefulWidget {
  @override
  _FavoritesContainer createState() => _FavoritesContainer();
}

class _FavoritesContainer extends State<FavoritesContainer> {
  List<FavoriteCard> favList = [];
  List<Streamer> listOfFavs = [];

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {
      getStreamerList();
    });
    // getList().then(updateCategoryList);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    // getStreamerList();
    return Container(
      height: 1000,
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: favList
          ),
        ),
    );
  }
  /// Gets a list of streamers.
  Future<List<FavoriteCard>> getStreamerList() async {
    List<FavoriteCard> streamerList = new List<FavoriteCard>();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    var getStreamerList = await d.getFavorites();


    if (getStreamerList != null) {
      for (int i = 0; i < getStreamerList.length; i++) {
        temp = getStreamerList[i]["fk_broadcaster_id"];
        FavoriteCard favCard = new FavoriteCard(temp.toString());
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


  @override
  void initState() {
    getStreamerList();
    super.initState();
  }
}
