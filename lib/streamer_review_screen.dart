import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  @override
  StreamerReview  createState() => new StreamerReview ();
}

class StreamerReview extends State<ReviewPage> {
  static const String username = 'Temp Username';
  double satisfaction_rating;
  double entertainment_rating;
  double interaction_rating;
  String dropdownValue = 'Gaming';

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      "Reviewing " + username,
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                                    "Category",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: <String>[
                                      'Gaming',
                                      'Food & Drinks',
                                      'Sports & Fitness',
                                      'Talk Shows & Podcasts',
                                      'Just Chatting',
                                      'Makers & Crafting',
                                      'Tabletop RPGs',
                                      'Science & Technologies',
                                      'Music & Performing Arts',
                                      'Beauty & Body Art',
                                      'Travel & Outdoors',
                                      'ASMR',
                                    ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                                    "Overall Satisfaction",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 3,
                                    itemCount: 5,
                                    itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, index) {
                                      switch (index) {
                                        case 0:
                                          return Icon(
                                            Icons.sentiment_very_dissatisfied,
                                            color: Colors.red,
                                          );
                                        case 1:
                                          return Icon(
                                            Icons.sentiment_dissatisfied,
                                            color: Colors.yellow[900],
                                          );
                                        case 2:
                                          return Icon(
                                            Icons.sentiment_neutral,
                                            color: Colors.amber[700],
                                          );
                                        case 3:
                                          return Icon(
                                            Icons.sentiment_satisfied,
                                            color: Colors.limeAccent[700],
                                          );
                                        case 4:
                                          return Icon(
                                            Icons.sentiment_very_satisfied,
                                            color: Colors.greenAccent[700],
                                          );
                                      }
                                    },
                                    onRatingUpdate: (rating) {
                                      satisfaction_rating = rating;
                                      print(rating);
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
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                                    "Entertainment Value",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 3.5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    onRatingUpdate: (rating) {
                                      entertainment_rating = rating;
                                      print(rating);
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
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                                    "Viewer Interaction",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    onRatingUpdate: (rating) {
                                      interaction_rating = rating;
                                      print(rating);
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
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
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
                                              maxWidth: 150.0, minHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "RETURN",
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

