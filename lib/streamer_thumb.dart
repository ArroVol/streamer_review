import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamer_review/streamer_screen.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';

class StreamerThumb extends StatefulWidget {
  String streamerURL;
  String streamerName;
  Color ambientColor;
  int numberOfViewers;

  StreamerThumb(String streamerName, String streamerURL, Color ambientColor,
      int numberOfViewers) {
    this.streamerName = streamerName;
    this.streamerURL = streamerURL;
    this.ambientColor = ambientColor;
    this.numberOfViewers = numberOfViewers;
  }

  @override
  _StreamerThumb createState() =>
      _StreamerThumb(streamerName, streamerURL, ambientColor, numberOfViewers);
}

class _StreamerThumb extends State<StreamerThumb> {
  String streamerName;
  String streamerID;
  String imageURL;
  Color backgroundColor;
  Color contrastColor;
  int numberOfViewers;

  _StreamerThumb(streamerName, imageURL, ambientColor, int numberOfViewers) {
    this.streamerName = streamerName;
    this.imageURL = imageURL;
    this.backgroundColor = ambientColor;
    this.contrastColor =
    ambientColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    this.numberOfViewers = numberOfViewers;

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: 5,
      shadowColor: backgroundColor,
      shape: RoundedRectangleBorder(),
      child: new InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamerPage(streamerName)));
        },
        child: Container(
          width: 150.0,
          height: 150.0,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text(
                    numberOfViewers.toString(),
                    style: TextStyle(
                        color: this.numberOfViewers >= 0
                            ? contrastColor
                            : backgroundColor),
                  ),
                  Icon(
                    Icons.contactless,
                    color: this.numberOfViewers >= 0
                        ? contrastColor
                        : backgroundColor,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              Text(
                streamerName,
                style: TextStyle(color: contrastColor),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(imageURL),
                backgroundColor: Colors.black54,
                radius: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
