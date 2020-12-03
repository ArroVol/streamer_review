import 'package:flutter/material.dart';
import 'landing_card.dart';

class SearchContainer extends StatefulWidget {
  List<String> streamerList;

  SearchContainer(List<String> streamerList) {
    this.streamerList = streamerList;
  }
  @override
  _SearchContainer  createState() => _SearchContainer (streamerList);
}

class _SearchContainer  extends State<SearchContainer > {
  List<String> streamerList;

  _SearchContainer(List<String> streamerList) {
    this.streamerList = streamerList;
  }


  List<LandingCard> searchList = [];

  @override
  Widget build(BuildContext context) {
    getStreamerList();
    return Container(
      height: 500,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: searchList,
      ),
    );
  }

  var temp;

  Future<List<LandingCard>> getStreamerList() async {
    List<LandingCard> streamerList1 = new List<LandingCard>();

      int tempCount =0;
    if (streamerList != null) {
      for (int i = 0; i < 9; i++) {
        if (streamerList.length < tempCount){
          continue;
        }else {
          temp = streamerList[i];
          LandingCard landCard = new LandingCard(temp.toString());
          streamerList1.add(landCard);
          tempCount++;
        }
      }
    }
    if (streamerList1 != null) {
      setState(() {
        searchList = streamerList1;
      });
    }
    return streamerList1;
  }


  @override
  void initState() {
    getStreamerList();
    super.initState();
  }
}
