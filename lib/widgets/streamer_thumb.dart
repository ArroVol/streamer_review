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

  StreamerThumb(String streamerName, String streamerURL, Color ambientColor){
    this.streamerName = streamerName;
    this.streamerURL = streamerURL;
    this.ambientColor = ambientColor;
  }


  @override
  _StreamerThumb createState() => _StreamerThumb(streamerName, streamerURL, ambientColor);
}

class _StreamerThumb extends State<StreamerThumb> {
  String streamerName;
  String streamerID;
  String imageURL;
  Color backgroundColor;
  Color contrastColor;

  _StreamerThumb(streamerName, imageURL, ambientColor){
    this.streamerName = streamerName;
    this.imageURL = imageURL;
    this.backgroundColor = ambientColor;
    this.contrastColor = ambientColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
   }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: 10,
      shadowColor: backgroundColor,
      shape: RoundedRectangleBorder(),
      child: new InkWell(
        onTap: () {
          print("Streamer card clicked");
          Navigator.push(context, MaterialPageRoute(builder: (context) => StreamerPage(streamerName)));
        },
        child: Container(
          width: 150.0,
          height: 150.0,
          child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(imageURL),
                backgroundColor: Colors.black54,
                radius: 45,
              ),
              Text(
                  streamerName,
              style: TextStyle(color: contrastColor),
              ),
              Icon(Icons.contactless, color: contrastColor),
            ],
          ),
        ),
      ),
    );
  }

}