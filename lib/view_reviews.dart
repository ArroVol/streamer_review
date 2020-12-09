import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamer_review/review_card.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'package:streamer_review/review_container.dart';
import 'helper/database_helper.dart';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPage createState() => new _ReviewsPage();
}

class _ReviewsPage extends State<ReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'STREVIEW',
          style: TextStyle(color: Colors.lightGreenAccent, letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
        body: Container(
          child:  ReviewsContainer(),
        ),
    );
  }
}
