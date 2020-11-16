import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StreamerThumb extends StatefulWidget {
  @override
  _StreamerThumb createState() => _StreamerThumb();
}

class _StreamerThumb extends State<StreamerThumb> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 100,
        child: Center(
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/example.jpg'),
            radius: 35,
          ),
        ),
      );
  }
}
