import 'package:flutter/material.dart';
import 'landing_card.dart';

class SearchContainer extends StatefulWidget {
  List<String> streamerList;

  SearchContainer(List<String> streamerList) {
    this.streamerList = streamerList;
  }

  @override
  _SearchContainer createState() => _SearchContainer(streamerList);
}

class _SearchContainer extends State<SearchContainer> {
  List<String> streamerList;

  _SearchContainer(List<String> streamerList) {
    this.streamerList = streamerList;
  }

  List<LandingCard> searchList = [];

  @override
  Widget build(BuildContext context) {
    getStreamerList();
    return Container(
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) =>
          Container(
            child: LandingCard(streamerList[index].toString())
          ),
          itemCount: searchList.length,
        ),
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   getStreamerList();
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       physics: NeverScrollableScrollPhysics(),
  //       child: ConstrainedBox(
  //         constraints: BoxConstraints(
  //           minWidth: MediaQuery.of(context).size.width,
  //           minHeight: MediaQuery.of(context).size.height,
  //         ),
  //         child: IntrinsicHeight(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.max,
  //             children: <Widget>[
  //
  //
  //               // CONTENT HERE
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  var temp;

  Future<List<LandingCard>> getStreamerList() async {
    List<LandingCard> streamerList1 = new List<LandingCard>();

    int tempCount = 0;
    if (streamerList != null) {
      for (int i = 0; i < streamerList.length; i++) {
        if (streamerList.length < tempCount) {
          continue;
        } else {
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
