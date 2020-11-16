import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/streamer_review_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    home: new StreamerPage(),
  ));
}

class StreamerPage extends StatefulWidget {
  @override
  StreamerProfile createState() => new StreamerProfile();
}

class StreamerProfile extends State<StreamerPage> {
  var data;
  var topStreamerInfo;
  Streamer topStreamer;

  Future<Streamer> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://api.twitch.tv/helix/streams?first=100"),
        headers: {
          "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
          "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
        }
    );
    topStreamerInfo = json.decode(response.body);
    print(topStreamerInfo['data'][0]);
    var topStreamerId = topStreamerInfo['data'][0]['user_id'];

    var url = "https://api.twitch.tv/helix/users?id=" + topStreamerId;
    print(url);

    http.Response channelInformation = await http.get(
        Uri.encodeFull(url),
        headers: {
          "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
          "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
        }
    );

    data = json.decode(channelInformation.body);
    var username = data['data'][0]['display_name'];
    var description = data['data'][0]['description'];
    var profilePictureUrl = data['data'][0]['profile_image_url'];
    var viewCount = data['data'][0]['view_count'];
    var streamer = new Streamer(
        username, description, profilePictureUrl, viewCount);
    print(streamer.username);
    print(streamer.description);
    print(streamer.profilePictureUrl);
    print(streamer.viewCount);


    var streamers = List();

    // for (var i = 0; i < data['data'].length; i++) {
    //   var username = data['data'][i]['user_name'];
    //
    //   var profilePictureUrl = data['data'][i]['thumbnail_url'];
    //   var viewCount = data['data'][i]['viewer_count'];
    //   // var streamer = new Streamer(username, profilePictureUrl, numberOfSubscribers);
    //   // streamers.add(streamer);
    //   // streamers2.putIfAbsent(streamer.username, () => streamer);
    // }
    print(streamers.length);

    setState(() {
      topStreamer = streamer;
    });
    return streamer;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  static const String audience = "PG-13";
  static const String overallRating = "4/5";
  static const String satisfaction = "4/5";
  static const String interaction = "4/5";
  static const String entertainment = "4/5";

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple[900], Colors.white],
                    stops: [0.2, 1],
                  )),
              child: Container(
                width: double.infinity,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .9,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          topStreamer.profilePictureUrl,
                        ),
                        radius: 75.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        topStreamer.username,
                        style: TextStyle(
                          fontSize: 26.0,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                topStreamer.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Channel Views",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      topStreamer.viewCount.toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Audience Ratings",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Overall Rating: " + overallRating,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "General Satisfaction: " + satisfaction,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Interaction: " + interaction,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Entertainment: " + entertainment,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RaisedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewPage()));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(80.0)),
                                        elevation: 0.0,
                                        padding: EdgeInsets.all(0.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  Colors.deepPurpleAccent,
                                                  Colors.deepPurple[700]
                                                ]),
                                            borderRadius:
                                            BorderRadius.circular(30.0),
                                          ),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 150.0,
                                                minHeight: 50.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "REVIEW",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
