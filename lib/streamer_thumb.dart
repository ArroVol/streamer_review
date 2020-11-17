import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StreamerThumb extends StatefulWidget {
  @override
  _StreamerThumb createState() => _StreamerThumb();
}

class _StreamerThumb extends State<StreamerThumb> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 50,
      shadowColor: Colors.lightGreenAccent[100],
      shape: CircleBorder(),
      child: new InkWell(
        onTap: () {
          print("Streamer card clicked");
        },
        child: Container(
          width: 150.0,
          height: 150.0,
          child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('assets/example.jpg'),
                backgroundColor: Colors.lightGreenAccent,
                radius: 35,
              ),
              Text('Ninja'),
              Icon(Icons.contactless, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
