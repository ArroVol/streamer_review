import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/streamer_review_screen.dart';
import 'package:streamer_review/streamer_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';
import 'model/broadcaster_from_db.dart';

class ReviewCard extends StatefulWidget {
  String streamerId;

  ReviewCard(String streamerId) {
    this.streamerId = streamerId;
  }

  @override
  _ReviewCard createState() => _ReviewCard(streamerId);
}

class _ReviewCard extends State<ReviewCard> {
  String streamerId;

  _ReviewCard(String streamerId) {
    this.streamerId = streamerId;
    getData();
  }

  var data;
  var topStreamerInfo;
  Streamer topStreamer;
  TextReview textReview;
  var average_satisfaction_rating;
  var average_entertainment_rating;
  var average_interaction_rating;
  var average_skill_rating;
  String broadcaster_id;
  BroadcasterFromDB broadcasterFromDB;
  int user_id = 1;
  BroadcasterFromDB b;
  bool offline = false;
  String userName;
  var overall_average;

  Future<String> getData() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;

    await d.selectUserTextReviews(streamerId).then((value) {
      if (value.isNotEmpty) {
        textReview = new TextReview(
            value[0]['review_content'], value[0]['submission_date']);
      } else {
        textReview = new TextReview("", "");
      }
    }, onError: (error) {
      print(error);
    });
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
    // await d.updateBroadcaster(broadcaster_id, user_id, login);

    setState(() {
      // topStreamer = streamer;
      if (b != null) {
        broadcasterFromDB = b;
        average_satisfaction_rating = broadcasterFromDB.overall_satisfaction;
        average_entertainment_rating = broadcasterFromDB.overall_entertainment;
        average_interaction_rating = broadcasterFromDB.overall_interactiveness;
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
    // print(
    //     "making card++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return userName;
  }

  var averageScore;

  void calcScore() {
    averageScore = (average_entertainment_rating +
            average_satisfaction_rating +
            average_interaction_rating +
            average_skill_rating) /
        4;
  }

  void deleteReview() {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    d.clearSelectedReview(int.parse(streamerId));
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      clipBehavior: Clip.antiAlias,
      color: Colors.grey[850],
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 17.0,
          ),
          Text(
            userName.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
              ),
              RatingBar.builder(
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
          SizedBox(height: 10.0),
          textReview.reviewContent != ""
              ? Text(
                  textReview.reviewContent.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12.0,
                      // fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                )
              : SizedBox(
                  height: 0.0,
                ),
          Card(
            // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 5.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.person, color: Colors.grey[400]),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StreamerPage(userName)));
                          setState(() {});
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.delete, color: Colors.grey[400]),
                      //   onPressed: () {
                      //     deleteReview();
                      //     setState(() {});
                      //   },
                      // ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey[400]),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewPage(streamerId))).then((value) {
                            // getData();
                            setState(() {
                              getData();

                              // refresh state
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ),
        ],
      ),
    );
  }
}

class TextReview {
  String reviewContent;
  String date;

  TextReview(String reviewContent, String date) {
    this.reviewContent = reviewContent;
    this.date = date;
  }
}
