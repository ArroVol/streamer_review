import 'package:palette_generator/palette_generator.dart';
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

  var text_reviews = [];
  var data;
  var topStreamerInfo;
  Streamer topStreamer;
  BroadcasterFromDB broadcasterFromDB;
  var average_satisfaction_rating;
  var average_entertainment_rating;
  var average_interaction_rating;
  var average_skill_rating;
  var overall_average;
  String broadcaster_id;
  BroadcasterFromDB b;
  bool offline = false;
  bool isFavorite = false;
  Color ambientColor;
  Color contrastColor;
  Color ambientColorVarient;
  Color oppositeContrast;
  bool upPressed = false;
  bool downPressed = false;
  List<bool> upPresses = [];
  List<bool> downPresses = [];
  String dropdownValue = 'Top Rated';

  Future<void> getReviews(order) async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    var reviews;
    if (order == 'Top Rated') {
      reviews = await d.selectTextReviewsByScore(broadcaster_id);
    } else {
      reviews = await d.selectTextReviews(broadcaster_id);
    }
    List<int> temp2 = [];
    for (var review in reviews) {
      int x = await d.selectReviewScoreByReviewIdAndUserId(review['favorites_id']);
      temp2.add(x);
    }
    List<bool> tempUpPresses = [];
    List<bool> tempDownPresses = [];

    for(int score in temp2) {
      if(score == 0) {
        tempUpPresses.add(false);
        tempDownPresses.add(false);
      } else if(score == 1) {
        tempUpPresses.add(true);
        tempDownPresses.add(false);
      } else if(score == -1) {
        tempUpPresses.add(false);
        tempDownPresses.add(true);
      }
    }

    setState(() {
      text_reviews = reviews;
      upPresses = tempUpPresses;
      downPresses = tempDownPresses;
    });
  }

  Future<Streamer> getData() async {
    var url = 'https://api.twitch.tv/helix/search/channels?query=' + selection;

    http.Response response = await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    topStreamerInfo = json.decode(response.body);
    ;
    var temp;
    for (int i = 0; i < topStreamerInfo['data'].length; i++) {
      if (topStreamerInfo['data'][i]['display_name'].toString().toLowerCase() ==
          selection.toLowerCase()) {
        temp = topStreamerInfo['data'][i];
        break;
      }
    }

    var topStreamerId = temp['id'];
    broadcaster_id = topStreamerId;

    url = "https://api.twitch.tv/helix/users?id=" + topStreamerId;

    http.Response channelInformation =
        await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    data = json.decode(channelInformation.body);

    // var username = data['data'][0]['display_name'];
    var login = data['data'][0]['login'];
    var description = data['data'][0]['description'];
    var profilePictureUrl = data['data'][0]['profile_image_url'];
    var viewCount = data['data'][0]['view_count'];
    var streamerImageURL =
        // await updateImage(streamerMap[i]['broadcaster_id'].toString());
        ambientColor = await getImagePalette(profilePictureUrl);

    // ambientColorVarient = await getImagePalette2(profilePictureUrl);
    contrastColor =
        ambientColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    ambientColorVarient = ambientColor.computeLuminance() > 0.5 ? Colors.grey[850] : Colors.grey[300];
    oppositeContrast =
        contrastColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    var streamer =
        new Streamer(login, description, profilePictureUrl, viewCount);
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    // var x = await d.selectBroadcaster(broadcaster_id);
    await d.selectBroadcaster(topStreamerId).then((value) {
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
    await d.updateBroadcaster(broadcaster_id, login);
    var reviews = await d.selectTextReviewsByScore(broadcaster_id);
    List<int> temp2 = [];

    for (var review in reviews) {
      int x =
          await d.selectReviewScoreByReviewIdAndUserId(review['favorites_id']);
      temp2.add(x);
    }

    List<bool> tempUpPresses = [];
    List<bool> tempDownPresses = [];

    for (int score in temp2) {
      if (score == 0) {
        tempUpPresses.add(false);
        tempDownPresses.add(false);
      } else if (score == 1) {
        tempUpPresses.add(true);
        tempDownPresses.add(false);
      } else if (score == -1) {
        tempUpPresses.add(false);
        tempDownPresses.add(true);
      }
    }

    var url2 = "https://api.twitch.tv/helix/search/channels?query=" + login;

    http.Response channelInformation2 =
        await http.get(Uri.encodeFull(url2), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    data = json.decode(channelInformation2.body);
    offline = data['data'][0]['is_live'];

    bool tempIsFavorite = await d.isFavorite(int.parse(broadcaster_id));
    setState(() {
      topStreamer = streamer;
      text_reviews = reviews;
      upPresses = tempUpPresses;
      downPresses = tempDownPresses;
      isFavorite = tempIsFavorite;

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
          overall_average = 0.0;
        } else {
          overall_average = (average_satisfaction_rating +
                  average_entertainment_rating +
                  average_interaction_rating +
                  average_skill_rating) /
              4;
        }
      } else {
        broadcasterFromDB = new BroadcasterFromDB(0, 0, 0, 0);
        average_satisfaction_rating = 0;
        average_entertainment_rating = 0;
        average_interaction_rating = 0;
        average_skill_rating = 0;
        overall_average = 0;
      }
    });

    return streamer;
  }

  Future<Color> getImagePalette(String streamerImageURL) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            NetworkImage(streamerImageURL));
    return paletteGenerator.dominantColor.color;
  }

  Future<Color> getImagePalette2(String streamerImageURL) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            NetworkImage(streamerImageURL));

    return ambientColor.computeLuminance() > 0.5
        ? paletteGenerator.darkVibrantColor.color
        : paletteGenerator.lightMutedColor.color;
  }

  void updateReview(review_id, upPressed, downPressed) async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    if (!upPressed && !downPressed) {
      await d.insertTextReviewScore(review_id, 0);
    } else if (upPressed && !downPressed) {
      await d.insertTextReviewScore(review_id, 1);
    } else if (!upPressed && downPressed) {
      await d.insertTextReviewScore(review_id, -1);
    }
    getData();

    setState(() {});
  }

  Future<void> favorite() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    if (!isFavorite) {
      isFavorite = true;
      await d.insertFavorite(int.parse(broadcaster_id));
    } else {
      isFavorite = false;
      await d.deleteFavorite(int.parse(broadcaster_id));
    }

    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    // getData();
    final rev = text_reviews;
    return Scaffold(
      backgroundColor: topStreamer == null ? Colors.black : ambientColor,
      appBar: AppBar(
          title: Text(
            'STREVIEW',
            style:
                TextStyle(color: Colors.lightGreenAccent, letterSpacing: 1.5),
          ),
          actions: <Widget>[
            topStreamer == null
                ? Icon(Icons.favorite, color: Colors.transparent)
                : IconButton(
                    icon: isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(
                            Icons.favorite_border,
                          ),
                    onPressed: () {
                      favorite();
                    }),
          ],
          centerTitle: true,
          backgroundColor: Colors.grey[850]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
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
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                          ),
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: contrastColor,
                            child: CircleAvatar(
                              radius: 75.0,
                              backgroundImage:
                                  NetworkImage(topStreamer.profilePictureUrl),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            topStreamer.username,
                            style: TextStyle(
                              fontSize: 26.0,
                              color: topStreamer == null
                                  ? Colors.black
                                  : contrastColor,
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
                                  // Align(
                                  //   alignment: Alignment.centerLeft,
                                  // ),
                                  Text(
                                    topStreamer.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: topStreamer == null
                                          ? Colors.black
                                          : contrastColor,
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
                            shadowColor: Colors.transparent,
                            color: topStreamer == null
                                ? Colors.black
                                : contrastColor,
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 22.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        IconButton(
                                            icon:  Icon(Icons.settings_input_antenna_sharp, color: offline ? Colors.lightGreenAccent : Colors.red, size: 40),
                                            onPressed: () {
                                              favorite();
                                            }),
                                        // RaisedButton(
                                        //     onPressed: openUrl,
                                        //     shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(
                                        //                 80.0)),
                                        //     elevation: 0.0,
                                        //     padding: EdgeInsets.all(0.0),
                                        //     child: Ink(
                                        //       decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(30.0),
                                        //         color: !offline
                                        //             ? Colors.red
                                        //             : Colors.lightGreenAccent,
                                        //       ),
                                        //       child: Container(
                                        //         constraints: BoxConstraints(
                                        //             maxWidth: 125.0,
                                        //             minHeight: 50.0),
                                        //         alignment: Alignment.center,
                                        //         child: Text(
                                        //           "OPEN URL",
                                        //           style: TextStyle(
                                        //               color: Colors.grey[850],
                                        //               fontSize: 22.0,
                                        //               fontWeight:
                                        //                   FontWeight.bold),
                                        //         ),
                                        //       ),
                                        //     )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        RaisedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReviewPage(
                                                                  broadcaster_id)))
                                                  .then((value) {
                                                setState(() {
                                                  getData();
                                                });
                                              });
                                            },
                                            // shape: RoundedRectangleBorder(
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             80.0)),
                                            elevation: 0.0,
                                            padding: EdgeInsets.all(0.0),
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                // borderRadius:
                                                //     BorderRadius.circular(30.0),
                                                color: ambientColor,
                                              ),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 125.0,
                                                    minHeight: 50.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "REVIEW",
                                                  style: TextStyle(
                                                      color: contrastColor,
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
                          ),
                          Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            clipBehavior: Clip.antiAlias,
                            shadowColor: Colors.transparent,
                            color: topStreamer == null
                                ? Colors.black
                                : contrastColor,
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 22.0),
                              child: Row(
                                children: <Widget>[
                                  average_skill_rating == null
                                      ? new Container(
                                          child: new Center(
                                            child: new SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          oppositeContrast)),
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Audience Ratings",
                                                style: TextStyle(
                                                  color: topStreamer == null
                                                      ? Colors.black
                                                      : oppositeContrast,
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
                                                  color: topStreamer == null
                                                      ? Colors.black
                                                      : oppositeContrast,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              overall_average == 0.0
                                                  ? Text(
                                                      "n/a",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color:
                                                            topStreamer == null
                                                                ? Colors.black
                                                                : ambientColor,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                              overall_average,
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemSize: 30.0,
                                                          unratedColor: Colors.grey[600],
                                                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: topStreamer ==
                                                                    null
                                                                ? Colors.black
                                                                : ambientColor,
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
                                                  color: topStreamer == null
                                                      ? Colors.black
                                                      : oppositeContrast,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              average_satisfaction_rating == 0
                                                  ? Text(
                                                      "n/a",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color:
                                                            topStreamer == null
                                                                ? Colors.black
                                                                : ambientColor,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                          unratedColor: Colors.grey[600],
                                                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: topStreamer ==
                                                                    null
                                                                ? Colors.black
                                                                : ambientColor,
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
                                                  color: topStreamer == null
                                                      ? Colors.black
                                                      : oppositeContrast,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              average_satisfaction_rating == 0
                                                  ? Text(
                                                      "n/a",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color:
                                                            topStreamer == null
                                                                ? Colors.black
                                                                : ambientColor,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                              average_interaction_rating,
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemSize: 30.0,
                                                          unratedColor: Colors.grey[600],
                                                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: topStreamer ==
                                                                    null
                                                                ? Colors.black
                                                                : ambientColor,
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
                                                  color: topStreamer == null
                                                      ? Colors.black
                                                      : oppositeContrast,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              average_satisfaction_rating == 0
                                                  ? Text(
                                                      "n/a",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color:
                                                            topStreamer == null
                                                                ? Colors.black
                                                                : ambientColor,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                              average_entertainment_rating,
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemSize: 30.0,
                                                          unratedColor: Colors.grey[600],
                                                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: topStreamer ==
                                                                    null
                                                                ? Colors.black
                                                                : ambientColor,
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
                                                  color: topStreamer == null
                                                      ? Colors.black
                                                      : oppositeContrast,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              average_satisfaction_rating == 0
                                                  ? Text(
                                                      "n/a",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color:
                                                            topStreamer == null
                                                                ? Colors.black
                                                                : ambientColor,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                              average_skill_rating,
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemSize: 30.0,
                                                          unratedColor: Colors.grey[600],
                                                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: topStreamer ==
                                                                    null
                                                                ? Colors.black
                                                                : ambientColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ]),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "User Comments",
                        style: TextStyle(
                            color: contrastColor,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward, color: contrastColor),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: contrastColor),
                        underline: Container(
                          height: 2,
                          color: contrastColor,
                        ),
                        onChanged: (String newValue) {
                          getReviews(newValue);
                          dropdownValue = newValue;
                        },
                        items: <String>['Top Rated', 'Most Recent']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: contrastColor),
                              ));
                        }).toList(),
                      ),
                      //dropdown here
                    ],
                  ),
                ),
              ],
            ),
            // Text('User Comments'),
            ListView.builder(
              shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                clipBehavior: Clip.antiAlias,
                color: topStreamer == null ? Colors.black : contrastColor,
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 0.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 17.0,
                      ),
                      Text(
                        rev[index]['submission_date'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: ambientColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(rev[index]['review_content'],
                          style:
                              TextStyle(color: oppositeContrast, fontSize: 20)),
                      Card(
                        // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: new ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(rev[index]['score'].toString(),
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 20)),
                                  IconButton(
                                      icon: upPresses[index]
                                          ? Icon(
                                              Icons.thumb_up_alt,
                                              color: ambientColor,
                                            )
                                          : Icon(
                                              Icons.thumb_up_alt_outlined,
                                              color: ambientColor,
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          // Here we changing the icon.
                                          if (!upPresses[index]) {
                                            upPresses[index] = true;
                                            downPresses[index] = false;
                                          } else {
                                            upPresses[index] = false;
                                          }
                                          updateReview(
                                              rev[index]['favorites_id'],
                                              upPresses[index],
                                              downPresses[index]);
                                        });
                                      }),
                                  IconButton(
                                      icon: downPresses[index]
                                          ? Icon(
                                              Icons.thumb_down_alt,
                                              color: ambientColor,
                                            )
                                          : Icon(
                                              Icons.thumb_down_alt_outlined,
                                              color: ambientColor,
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          // Here we changing the icon.
                                          if (!downPresses[index]) {
                                            downPresses[index] = true;
                                            upPresses[index] = false;
                                          } else {
                                            downPresses[index] = false;
                                          }
                                          updateReview(
                                              rev[index]['favorites_id'],
                                              upPresses[index],
                                              downPresses[index]);
                                        });
                                      }),
                                ],
                              ),
                              // ListTile(
                              //   // leading: Icon(Icons.gamepad),
                              //   title: Text(rev[index]['submission_date'],style: TextStyle(
                              //       color: ambientColor, fontSize: 14) ),
                              //   subtitle: Text(rev[index]['review_content'] +
                              //       '\n' +
                              //       rev[index]['score'].toString(), style: TextStyle(
                              //       color: oppositeContrast, fontSize: 20) ),
                              //   isThreeLine: true,
                              //   trailing: Row(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: <Widget>[
                              //       IconButton(
                              //           icon: upPresses[index]
                              //               ? Icon(
                              //                   Icons.thumb_up_alt,
                              //                   color: oppositeContrast,
                              //                 )
                              //               : Icon(
                              //                   Icons.thumb_up_alt_outlined,
                              //                   color: oppositeContrast,
                              //                 ),
                              //           onPressed: () {
                              //             setState(() {
                              //               // Here we changing the icon.
                              //               if (!upPresses[index]) {
                              //                 upPresses[index] = true;
                              //                 downPresses[index] = false;
                              //               } else {
                              //                 upPresses[index] = false;
                              //               }
                              //               updateReview(rev[index]['favorites_id'],
                              //                   upPresses[index], downPresses[index]);
                              //             });
                              //           }),
                              //       IconButton(
                              //           icon: downPresses[index]
                              //               ? Icon(
                              //                   Icons.thumb_down_alt,
                              //                   color: oppositeContrast,
                              //                 )
                              //               : Icon(
                              //                   Icons.thumb_down_alt_outlined,
                              //                   color: oppositeContrast,
                              //                 ),
                              //           onPressed: () {
                              //             setState(() {
                              //               // Here we changing the icon.
                              //               if (!downPresses[index]) {
                              //                 downPresses[index] = true;
                              //                 upPresses[index] = false;
                              //               } else {
                              //                 downPresses[index] = false;
                              //               }
                              //               updateReview(rev[index]['favorites_id'],
                              //                   upPresses[index], downPresses[index]);
                              //
                              //             });
                              //           }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: rev.length,
            ),
          ],
        ),
      ),
    );
  }
}
