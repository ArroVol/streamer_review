import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streamer_review/streamer.dart';

class SettingsPage extends StatelessWidget {
  var data;
  var topStreamerInfo;
  Streamer topStreamer;

  Future<Streamer> getStreamInfo() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://api.twitch.tv/helix/search/channels?query=criticalrole"),
        headers: {
          "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
          "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
        });

    data = json.decode(response.body);
    print(data['data'][0]);

    var streamer = new Streamer('test', 'test', 'test', 10);
    return streamer;
  }

  Future<Streamer> getChannelInfo() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://api.twitch.tv/helix/users?id=229729353"),
        headers: {
          "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
          "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
        });

    data = json.decode(response.body);
    print(data['data'][0]);

    var streamer = new Streamer('test', 'test', 'test', 10);
    return streamer;
  }

  Future<Streamer> getTopStreamers() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://api.twitch.tv/helix/streams?first=100"),
        headers: {
          "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
          "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
        });

    data = json.decode(response.body);

    for (int i = 0; i < data['data'].length; i++) {
      int number = i + 1;
      print(number.toString() + '.) ' + data['data'][i]['user_name']);
    }
    var streamer = new Streamer('test', 'test', 'test', 10);
    return streamer;
  }

  Future<Streamer> getTopGames() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://api.twitch.tv/helix/games/top?first=10"),
        headers: {
          "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
          "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
        });

    data = json.decode(response.body);

    for (int i = 0; i < data['data'].length; i++) {
      int number = i + 1;
      print(number.toString() + '.) ' + data['data'][i]['name']);
    }
    var streamer = new Streamer('test', 'test', 'test', 10);
    return streamer;
  }

  Future<Streamer> getTopStreamer() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://api.twitch.tv/helix/streams?first=1"),
        headers: {
          "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
          "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
        });
    topStreamerInfo = json.decode(response.body);
    var topStreamerId = topStreamerInfo['data'][0]['user_id'];
    var topStreamerName = topStreamerInfo['data'][0]['user_name'];

    var url = "https://api.twitch.tv/helix/users?id=" + topStreamerId;

    http.Response channelInformation =
        await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });
    url =
        "https://api.twitch.tv/helix/search/channels?query=" + topStreamerName;
    http.Response isLiveInformation =
        await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });
    var isLive = json.decode(isLiveInformation.body);
    print('LIVE?: ' + isLive['data'][0]['is_live'].toString());

    data = json.decode(channelInformation.body);
    var username = data['data'][0]['display_name'];
    var description = data['data'][0]['description'];
    var profilePictureUrl = data['data'][0]['profile_image_url'];
    var viewCount = data['data'][0]['view_count'];
    var streamer =
        new Streamer(username, description, profilePictureUrl, viewCount);
    print('USERNAME: ' + streamer.username);
    print('DESCRIPTION: ' + streamer.description);
    print('PICTURE URL: ' + streamer.profilePictureUrl);
    print('VIEWS: ' + streamer.viewCount.toString());

    return streamer;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Test"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(40.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new TextField(
            //   keyboardType: TextInputType.text,
            //   decoration: new InputDecoration(hintText: "Search"),
            //   controller: t1,
            // ),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new MaterialButton(
                  child: new Text("Get Stream Info"),
                  color: Colors.greenAccent,
                  onPressed: getStreamInfo,
                ),
                new MaterialButton(
                  child: new Text("Get Channel Info"),
                  color: Colors.greenAccent,
                  onPressed: getChannelInfo,
                ),
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new MaterialButton(
                  child: new Text("Top 10 Games"),
                  color: Colors.greenAccent,
                  onPressed: getTopGames,
                ),
                new MaterialButton(
                  child: new Text("Top 100 Streamers"),
                  color: Colors.greenAccent,
                  onPressed: getTopStreamers,
                ),
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new MaterialButton(
                  child: new Text("Top Streamer"),
                  color: Colors.greenAccent,
                  onPressed: getTopStreamer,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
