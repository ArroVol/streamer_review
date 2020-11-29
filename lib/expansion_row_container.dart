import 'package:flutter/material.dart';
import 'file:///C:/Users/Brendan/AndroidStudioProjects/lab4/streamer_review/lib/widgets/streamer_thumb.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';

class ExpansionRowContainer extends StatefulWidget {
  @override
  _ExpansionRowContainerState createState() => _ExpansionRowContainerState();
}

class _ExpansionRowContainerState extends State<ExpansionRowContainer> {
  List<StreamerThumb> streamerThumb = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: streamerThumb,
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return new FutureBuilder(
//         future: getStreamerList(),
//         initialData: "Loading text..",
//         builder: (BuildContext context, AsyncSnapshot<String> text) {
//           return new ExpansionRowContainer(
//               padding: new EdgeInsets.all(8.0),
//               child: new Text(
//                 text.data,
//                 style: new TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 19.0,
//                 ),
//               ));
//         });
//   }

  Future<List<StreamerThumb>> getStreamerList() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    var streamerMap = await d.selectAllBroadcasters();
    List<StreamerThumb> streamerList = new List<StreamerThumb>();

    for(int i = 0; i < streamerMap.length; i++){
      StreamerThumb streamerThumb = new StreamerThumb(streamerMap[i]['broadcaster_name']);
      streamerList.add(streamerThumb);
    }
    print(streamerList.length);
    if (streamerList != null){
      setState(() {
        streamerThumb = streamerList;
      });
    }
    return streamerList;
  }
  @override
  void initState() {
    getStreamerList();
    super.initState();
  }
}