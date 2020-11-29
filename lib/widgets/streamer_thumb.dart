import 'dart:math';

import 'package:flutter/material.dart';
import 'package:streamer_review/streamer_screen.dart';

class StreamerThumb extends StatefulWidget {
  String streamerName;

  StreamerThumb(this.streamerName);

  @override
  _StreamerThumb createState() => _StreamerThumb(streamerName);
}

class _StreamerThumb extends State<StreamerThumb> {
  String streamerName;

  _StreamerThumb(this.streamerName);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 7,
      shadowColor: Colors.lightGreenAccent,
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
                backgroundImage: AssetImage('assets/example.jpg'),
                backgroundColor: Colors.black,
                radius: 35,
              ),
              Text(streamerName),
              Icon(Icons.contactless, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
