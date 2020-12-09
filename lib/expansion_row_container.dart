import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
// import 'file:///C:/Users/Brendan/AndroidStudioProjects/lab4/streamer_review/lib/widgets/streamer_thumb.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'package:streamer_review/streamer_thumb.dart';
import 'helper/database_helper.dart';
import 'package:http/http.dart' as http;

class ExpansionRowContainer extends StatefulWidget {
  String dbTag;
  ExpansionRowContainer(String dbTag){
    this.dbTag = dbTag;
  }

  @override
  _ExpansionRowContainerState createState() => _ExpansionRowContainerState(dbTag);
}

class _ExpansionRowContainerState extends State<ExpansionRowContainer> {
  List<StreamerThumb> streamerThumb = [];
  String imageURL;
  String dbTag;

  _ExpansionRowContainerState(String dbTag){
    this.dbTag = dbTag;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStreamerList(),
        builder: (context, data) {
          if (data.hasData) {
            return Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: streamerThumb,
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
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
    var streamerMap = await d.selectAllBroadcastersByBroadcasterTag(dbTag);
    List<StreamerThumb> streamerList = new List<StreamerThumb>();

    for (int i = 0; i < streamerMap.length; i++) {
      var broadcasterMap = await d.selectBroadcaster(streamerMap[i]['fk_broadcaster_id']);
      var streamerImageURL =
      await updateImage(broadcasterMap.first['broadcaster_id'].toString());
      Color ambientColor = await getImagePalette(streamerImageURL);
      var numberOfViewers = await getStreamerCurrentViewers(
          broadcasterMap.first['broadcaster_id'].toString());
      StreamerThumb streamerThumb = new StreamerThumb(
          broadcasterMap.first['broadcaster_name'],
          streamerImageURL,
          ambientColor,
          numberOfViewers);
      streamerList.add(streamerThumb);
    }
    if (streamerList != null) {
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

  Future<String> updateImage(String id) async {
    String url = "https://api.twitch.tv/helix/users?id=" + id;

    // print(url);

    http.Response channelInformation =
    await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });
    var data = json.decode(channelInformation.body);
    return data['data'][0]['profile_image_url'];
  }

  Future<Color> getImagePalette(String streamerImageURL) async {
    final PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(
        NetworkImage(streamerImageURL));
    return paletteGenerator.dominantColor.color;
  }

  Future<int> getStreamerCurrentViewers(String id) async {
    String url = 'https://api.twitch.tv/helix/streams?user_id=' + id;

    // print(url);

    http.Response channelInformation =
    await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });
    var data = json.decode(channelInformation.body);
    if (data['data'].isNotEmpty) {
      return (data['data'][0]['viewer_count']);
    } else {
      return -1;
    }
    return 10;
  }
}
