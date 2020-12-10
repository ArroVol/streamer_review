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

/// This class creates the the favorite card widget.
///
/// [streamerId], the id twitch gives to its broadcaster.
class FavoriteCard extends StatefulWidget {
  String streamerId;

  /// The favorite card constructor.
  ///
  /// [streamerId], the id of the broadcaster.
  FavoriteCard(String streamerId) {
    this.streamerId = streamerId;
  }

  @override
  _FavoriteCard createState() => _FavoriteCard(streamerId);
}
/// This class stores and gets broadcaster information and builds the favorite card widget.
class _FavoriteCard extends State<FavoriteCard> {
  String streamerId;

  _FavoriteCard(String streamerId) {
    this.streamerId = streamerId;
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
  String userName = '';


  /// This gets the broadcaster data from the database.
  Future<String> getData() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;

    await d.selectBroadcaster(streamerId).then((value) {
      if (value.isNotEmpty) {
        b = new BroadcasterFromDB(
            value[0]['overall_satisfaction'],
            value[0]['overall_skill'],
            value[0]['overall_entertainment'],
            value[0]['overall_interactiveness']);
        userName = value[0]['broadcaster_name'];
      }
    }, onError: (error) {
      print(error);
    });

    setState(() {
      if (b != null) {
        broadcasterFromDB = b;
        average_satisfaction_rating = broadcasterFromDB.overall_satisfaction;
        average_entertainment_rating =
            broadcasterFromDB.overall_entertainment;
        average_interaction_rating =
            broadcasterFromDB.overall_interactiveness;
        average_skill_rating = broadcasterFromDB.overall_skill;
        if (average_satisfaction_rating == "NaN") {
          average_satisfaction_rating = 0;
          average_entertainment_rating = 0;
          average_interaction_rating = 0;
          average_skill_rating = 0;
        } else {
          calcScore();
        }
      } else {
        broadcasterFromDB = new BroadcasterFromDB(0, 0, 0, 0);
      }
    });
    return userName;
  }

  var averageScore;

  // A method that calculates the average for the full rating of the broadcaster.
  void calcScore() {
    averageScore = (average_entertainment_rating +
        average_satisfaction_rating +
        average_interaction_rating +
        average_skill_rating) /
        4;
  }


  // Builds the favorite card widget.
  @override
  Widget build(BuildContext context) {
    getData();
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      clipBehavior: Clip.antiAlias,
      color: Colors.grey[850],
      elevation: 5.0,
      child: new InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StreamerPage(
                        userName,
                      )));
        },
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
          child: Column(
            children: <Widget>[
              ListTile(

                title: Text(
                  userName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5
                  ),
                ),
                subtitle: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                    ),
                    average_satisfaction_rating == 0
                        ? Text(
                      "n/a",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.lightGreenAccent[100],
                        fontWeight: FontWeight.w500,
                      ),
                    )
                        : RatingBar.builder(
                      initialRating: averageScore,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30.0,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.lightGreenAccent[100],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
