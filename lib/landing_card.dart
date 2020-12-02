import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/streamer_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';
import 'model/broadcaster_from_db.dart';

class LandingCard extends StatefulWidget {
  String streamerId;

  LandingCard(String streamerId) {
    this.streamerId = streamerId;
  }

  @override
  _LandingCard createState() => _LandingCard(streamerId);
}

class _LandingCard extends State<LandingCard> {
  String streamerId;

  _LandingCard(String streamerId) {
    this.streamerId = streamerId;
    getData();
  }

  var data;
  var topStreamerInfo;
  Streamer topStreamer;
  BroadcasterFromDB broadcasterFromDB;

  BroadcasterFromDB b;
  bool offline = false;

  Future<Streamer> getData() async {
    var url = "https://api.twitch.tv/helix/users?id=" + streamerId;
    http.Response channelInformation =
        await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });
    data = json.decode(channelInformation.body);
    if (data != null) {
      var login = data['data'][0]['login'];
      var description = data['data'][0]['description'];
      var profilePictureUrl = data['data'][0]['profile_image_url'];
      var viewCount = data['data'][0]['view_count'];
      var streamer =
          new Streamer(login, description, profilePictureUrl, viewCount);

      var url2 = "https://api.twitch.tv/helix/search/channels?query=" + login;

      http.Response channelInformation2 =
          await http.get(Uri.encodeFull(url2), headers: {
        "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
        "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
      });

      data = json.decode(channelInformation2.body);
      offline = data['data'][0]['is_live'];

      setState(() {
        topStreamer = streamer;

      });

      return streamer;
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Container(
      child: Container(
        child: topStreamer == null
          ? new Container(
              child: new Center(
                child: new SizedBox(
                  width: 75,
                  height: 75,
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Colors.lightGreenAccent)),
                ),
              ),
            )
          : ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  topStreamer.profilePictureUrl,
                ),
                radius: 30.0,
              ),
              title: Text(
                topStreamer.username,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                topStreamer.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12.0,
                ),
              ),
              trailing: !offline
                  ? new Icon(Icons.settings_input_antenna_sharp, color: Colors.transparent,  size: 20.0, )
                  : new Icon(Icons.settings_input_antenna_sharp, color: Colors.green, size: 20.0,),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StreamerPage(topStreamer.username)));
              },

            ),
      ),
         decoration: BoxDecoration( //                    <-- BoxDecoration
        border: Border(bottom: BorderSide()),
      ),
    );
  }
}
