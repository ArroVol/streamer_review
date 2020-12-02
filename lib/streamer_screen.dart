import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/streamer_review_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';
import 'model/broadcaster_from_db.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// void main() {
//   runApp(new MaterialApp(
//     home: new StreamerPage(),
//   ));
// }

class StreamerPage extends StatefulWidget {
  String selection;

  StreamerPage(String selection) {
    this.selection = selection;
  }

  // StreamerPage(selection, {Key key, @required this.selection}): super(key: key);

  @override
  StreamerProfile createState() => StreamerProfile(selection);
}

class StreamerProfile extends State<StreamerPage> {
  String selection;

  StreamerProfile(String selection) {
    this.selection = selection;
  }

  var data;
  var topStreamerInfo;
  Streamer topStreamer;
  BroadcasterFromDB broadcasterFromDB;
  var average_satisfaction_rating;
  var average_entertainment_rating;
  var average_interaction_rating;
  var average_skill_rating;
  String broadcaster_id;
  int user_id = 1;
  BroadcasterFromDB b;
  bool offline = false;
  bool isFavorite = false;

  Future<Streamer> getData() async {
    // print('SELECTION = ' + selection);

    var url = 'https://api.twitch.tv/helix/search/channels?query=' + selection;
    // print(url);

    http.Response response = await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    topStreamerInfo = json.decode(response.body);
    // print('!!!!!!!!!!!!!!!!!!!!!!!');
    // print(topStreamerInfo['data']);
    var temp;
    for (int i = 0; i < topStreamerInfo['data'].length; i++) {
      if (topStreamerInfo['data'][i]['display_name'].toString().toLowerCase() ==
          selection.toLowerCase()) {
        temp = topStreamerInfo['data'][i];
        break;
      }
    }
    // print(topStreamerInfo['data'][0]);
    // var topStreamerId = topStreamerInfo['data'][0]['id'];
    // print('TEMP');
    // print(temp);
    var topStreamerId = temp['id'];
    broadcaster_id = topStreamerId;

    url = "https://api.twitch.tv/helix/users?id=" + topStreamerId;

    // print(url);

    http.Response channelInformation =
        await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    data = json.decode(channelInformation.body);
    // print('HERE !!!!!');
    // print(data);
    // var username = data['data'][0]['display_name'];
    var login = data['data'][0]['login'];
    var description = data['data'][0]['description'];
    var profilePictureUrl = data['data'][0]['profile_image_url'];
    var viewCount = data['data'][0]['view_count'];
    var streamer =
        new Streamer(login, description, profilePictureUrl, viewCount);
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    // var x = await d.selectBroadcaster(broadcaster_id);
    // print(x);
    await d.selectBroadcaster(topStreamerId).then((value) {
      // print(value[0]);
      // print(value[0]['overall_satisfaction']);
      // print(value[0]['overall_skill']);
      // print(value[0]['overall_entertainment']);
      // print(value[0]['overall_interactiveness']);
      // print(value);
      if (value.isNotEmpty) {
        b = new BroadcasterFromDB(
            value[0]['overall_satisfaction'],
            value[0]['overall_skill'],
            value[0]['overall_entertainment'],
            value[0]['overall_interactiveness']);
      }
      // b = new BroadcasterFromDB(value[0]['overall_satisfaction'], value[0]['overall_skill'], value[0]['overall_entertainment'], value[0]['overall_interactiveness']);
    }, onError: (error) {
      print(error);
    });
    await d.updateBroadcaster(broadcaster_id, user_id, login);

    var url2 = "https://api.twitch.tv/helix/search/channels?query=" + login;
    // print(url);

    http.Response channelInformation2 =
        await http.get(Uri.encodeFull(url2), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    data = json.decode(channelInformation2.body);
    offline = data['data'][0]['is_live'];
    // print(isOnline);

    // print(streamer.username);
    // print(streamer.description);
    // print(streamer.profilePictureUrl);
    // print(streamer.viewCount);

    // for (var i = 0; i < data['data'].length; i++) {
    //   var username = data['data'][i]['user_name'];
    //
    //   var profilePictureUrl = data['data'][i]['thumbnail_url'];
    //   var viewCount = data['data'][i]['viewer_count'];
    //   // var streamer = new Streamer(username, profilePictureUrl, numberOfSubscribers);
    //   // streamers.add(streamer);
    //   // streamers2.putIfAbsent(streamer.username, () => streamer);
    // }
    // print(streamers.length);
    isFavorite = await d.isFavorite(int.parse(broadcaster_id));
    setState(() {
      topStreamer = streamer;
      // print(b);
      if (b != null) {
        // print('this is happening');
        broadcasterFromDB = b;
        average_satisfaction_rating = broadcasterFromDB.overall_satisfaction;
        average_entertainment_rating = broadcasterFromDB.overall_entertainment;
        average_interaction_rating = broadcasterFromDB.overall_interactiveness;
        average_skill_rating = broadcasterFromDB.overall_skill;

        if( average_satisfaction_rating == "NaN"){
          average_satisfaction_rating = 0;
          average_entertainment_rating =0;
          average_interaction_rating = 0;
          average_skill_rating = 0;
        }

        // print(broadcasterFromDB.overall_skill);
      } else {
        broadcasterFromDB = new BroadcasterFromDB(0, 0, 0, 0);
      }
      // print(topStreamerFromDB);
      // topStreamerFromDB = sfd;
    });
    // bool isFav = await d.isFavorite(int.parse(broadcaster_id));
    // if (isFav) {
    //   toggle = false;
    // } else {
    //   toggle = true;
    // }
    return streamer;
  }

  Future<void> favorite() async {
    String url = "https://api.twitch.tv/helix/users?id=" + broadcaster_id;

    http.Response channelInformation =
        await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    var data = json.decode(channelInformation.body);
    var login = data['data'][0]['login'];

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    if (!isFavorite) {
      await d.insertFavorite(int.parse(broadcaster_id));
    } else {
      await d.deleteFavorite(int.parse(broadcaster_id));
    }
  }

  void openUrl() {
    String url = 'https://www.twitch.tv/';
    if (topStreamer != null) {
      url += topStreamer.username;
    }
    launch(url);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  static const String audience = "PG-13";

  // static const String overallRating = "4/5";
  // static const String satisfaction = "4/5";
  // static const String interaction = "4/5";
  // static const String entertainment = "4/5";

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
          title: Text(
            'STREVIEW',
            style:
                TextStyle(color: Colors.lightGreenAccent, letterSpacing: 1.5),
          ),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.logout),
            //   alignment: Alignment.centerLeft,
            //   onPressed: () {
            //     secureStorage.deleteSecureData('email');
            //     secureStorage.deleteSecureData('password');
            //
            //     Navigator.of(context).pushReplacement(FadePageRoute(
            //       builder: (context) => LoginScreen(),
            //     ));
            //   },
            // ),
            // IconButton(
            //   icon: Icon(Icons.person),
            //   alignment: Alignment.centerLeft,
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/profile');
            //   },
            // ),
            IconButton(
                icon: isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(
                        Icons.favorite_border,
                      ),
                onPressed: () {
                  favorite();
                  setState(() {
                    // Here we changing the icon.
                    if (isFavorite) {
                      isFavorite = true;
                    } else {
                      isFavorite = false;
                    }
                  });
                }),
          ],
          centerTitle: true,
          backgroundColor: Colors.black54),
      floatingActionButton: !offline
          ? new FloatingActionButton(
              child: const Icon(Icons.settings_input_antenna_sharp),
              onPressed: openUrl,
              backgroundColor: Colors.red,
            )
          : new FloatingActionButton(
              child: const Icon(Icons.settings_input_antenna_sharp),
              onPressed: openUrl,
              backgroundColor: Colors.green,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple[900], Colors.white],
          stops: [0.2, 1],
        )),
        child: Container(
          child: ListView(
            scrollDirection: Axis.vertical,
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
                  height: MediaQuery.of(context).size.height,
                  child: topStreamer == null
                      ? new Container(
                          child: new Center(
                            child: new SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white)),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              // child: IconButton(
                              //   icon: Icon(
                              //     Icons.arrow_back,
                              //   ),
                              //   iconSize: 25,
                              //   color: Colors.white,
                              //   onPressed: () {
                              //     Navigator.pop(context);
                              //   },
                              // ),
                            ),
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
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text('Open Url'),
                                            onPressed: () {
                                              openUrl();
                                            },
                                          ),
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
                                      child:
                                      topStreamer == null
                                          ? new Container(
                                        child: new Center(
                                          child: new SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                AlwaysStoppedAnimation(Colors.white)),
                                          ),
                                        ),
                                      )
                                          : Column(
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
                                            "Overall Rating",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                         average_satisfaction_rating == 0
                                              ? Text(
                                                  "n/a",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.deepPurple,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Column(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                    ),
                                                    RatingBar.builder(
                                                      initialRating:
                                                          average_satisfaction_rating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          Text(
                                            // "General Satisfaction: " + broadcasterFromDB.overall_satisfaction.toString(),
                                            "General Satisfaction",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          average_satisfaction_rating == 0
                                              ? Text(
                                                  "n/a",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.deepPurple,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Column(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                    ),
                                                    RatingBar.builder(
                                                      initialRating: average_satisfaction_rating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          Text(
                                            // "Interaction: " + broadcasterFromDB.overall_interactiveness.toString(),
                                            "Interaction",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          average_satisfaction_rating == 0
                                              ? Text(
                                                  "n/a",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.deepPurple,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Column(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                    ),
                                                    RatingBar.builder(

                                                      initialRating: average_interaction_rating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          Text(
                                            // "Entertainment: " + broadcasterFromDB.overall_entertainment.toString(),
                                            "Entertainment",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          average_satisfaction_rating == 0
                                              ? Text(
                                                  "n/a",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.deepPurple,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Column(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                    ),
                                                    RatingBar.builder(

                                                      initialRating: average_entertainment_rating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          Text(
                                            // "Skill Level: " + broadcasterFromDB.overall_skill.toString(),
                                            "Skill Level",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          average_satisfaction_rating == 0
                                              ? Text(
                                                  "n/a",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.deepPurple,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Column(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                    ),
                                                    RatingBar.builder(

                                                      initialRating: average_skill_rating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ],
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
                                                            ReviewPage(
                                                                broadcaster_id)));
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0)),
                                              elevation: 0.0,
                                              padding: EdgeInsets.all(0.0),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.centerRight,
                                                      end: Alignment.centerLeft,
                                                      colors: [
                                                        Colors.deepPurpleAccent,
                                                        Colors.deepPurple[700]
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                        fontWeight:
                                                            FontWeight.bold),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
