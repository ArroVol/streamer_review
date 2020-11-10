import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {

  final String title;

  const ColorCircle({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text(this.title),
    ),
    );
  }
}
