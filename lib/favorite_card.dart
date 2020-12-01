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

class FavoriteCard extends StatefulWidget {
  String streamerId;

  FavoriteCard(String streamerId){
    this.streamerId= streamerId;
  }

  @override
  _FavoriteCard createState() => _FavoriteCard(streamerId);
}

class _FavoriteCard extends State<FavoriteCard> {
  String streamerId;

  _FavoriteCard(String streamerId) {
    this.streamerId = streamerId;
    print("int _FavoriteCard========================================================");
    getData();
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

  Future<Streamer> getData() async {
    print(
        "in getData in favorite card++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

    var url = "https://api.twitch.tv/helix/users?id=" + streamerId;
    print('HERE2');
    print(url);

    http.Response channelInformation =
        await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    data = json.decode(channelInformation.body);
    if(data!= null) {
      var login = data['data'][0]['login'];
      var description = data['data'][0]['description'];
      var profilePictureUrl = data['data'][0]['profile_image_url'];
      var viewCount = data['data'][0]['view_count'];
      var streamer =
      new Streamer(login, description, profilePictureUrl, viewCount);
      DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;

      await d.selectBroadcaster(streamerId).then((value) {
        if (value.isNotEmpty) {
          b = new BroadcasterFromDB(
              value[0]['overall_satisfaction'],
              value[0]['overall_skill'],
              value[0]['overall_entertainment'],
              value[0]['overall_interactiveness']);
        }
      }, onError: (error) {
        print(error);
      });
      await d.updateBroadcaster(broadcaster_id, user_id, login);

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
        if (b != null) {
          broadcasterFromDB = b;
          average_satisfaction_rating = broadcasterFromDB.overall_satisfaction;
          average_entertainment_rating = broadcasterFromDB.overall_entertainment;
          average_interaction_rating = broadcasterFromDB.overall_interactiveness;
          average_skill_rating = broadcasterFromDB.overall_skill;
        } else {
          broadcasterFromDB = new BroadcasterFromDB(0, 0, 0, 0);
        }
      });
      calcScore();
      return streamer;
    }

    // var login = data['data'][0]['login'];
    // var description = data['data'][0]['description'];
    // var profilePictureUrl = data['data'][0]['profile_image_url'];
    // var viewCount = data['data'][0]['view_count'];
    // var streamer =
    //     new Streamer(login, description, profilePictureUrl, viewCount);
    // DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    //
    // await d.selectBroadcaster(streamerId).then((value) {
    //   if (value.isNotEmpty) {
    //     b = new BroadcasterFromDB(
    //         value[0]['overall_satisfaction'],
    //         value[0]['overall_skill'],
    //         value[0]['overall_entertainment'],
    //         value[0]['overall_interactiveness']);
    //   }
    // }, onError: (error) {
    //   print(error);
    // });
    // await d.updateBroadcaster(broadcaster_id, user_id, login);
    //
    // var url2 = "https://api.twitch.tv/helix/search/channels?query=" + login;
    //
    // http.Response channelInformation2 =
    //     await http.get(Uri.encodeFull(url2), headers: {
    //   "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
    //   "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    // });
    //
    // data = json.decode(channelInformation2.body);
    // offline = data['data'][0]['is_live'];
    //
    // setState(() {
    //   topStreamer = streamer;
    //   if (b != null) {
    //     broadcasterFromDB = b;
    //     average_satisfaction_rating = broadcasterFromDB.overall_satisfaction;
    //     average_entertainment_rating = broadcasterFromDB.overall_entertainment;
    //     average_interaction_rating = broadcasterFromDB.overall_interactiveness;
    //     average_skill_rating = broadcasterFromDB.overall_skill;
    //   } else {
    //     broadcasterFromDB = new BroadcasterFromDB(0, 0, 0, 0);
    //   }
    // });
    // calcScore();
    print(
        "got the streamer data in favorite card++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    // return streamer;
  }

  var averageScore;

  void calcScore() {
    averageScore = (average_entertainment_rating +
            average_satisfaction_rating +
            average_interaction_rating +
            average_skill_rating) /
        4;
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 5.0,
      child: topStreamer == null
          ? new Container(
              child: new Center(
                child: new SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white)),
                ),
              ),
            )
          : new InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StreamerPage(
                              topStreamer.username,
                            )));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(topStreamer.profilePictureUrl),
                        radius: 30.0,
                      ),
                      title: Text(
                        topStreamer.username,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                          ),
                          RatingBar.builder(
                            initialRating: averageScore,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 30.0,
                            // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            // onRatingUpdate: (rating) {
                            //   // entertainment_rating = rating;
                            //   // print(rating);
                            // },
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.favorite,
                        size: 35.0,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                    // Column(
                    //     children: <Widget>[
                    //       RatingBar.builder(
                    //         initialRating: 3,
                    //         minRating: 1,
                    //         direction: Axis.horizontal,
                    //         allowHalfRating: false,
                    //         itemCount: 5,
                    //         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    //         itemBuilder: (context, _) => Icon(
                    //           Icons.star,
                    //           color: Colors.amber,
                    //         ),
                    //         onRatingUpdate: (rating) {
                    //           // entertainment_rating = rating;
                    //           // print(rating);
                    //         },
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ),
            ),
    );
  }
}
