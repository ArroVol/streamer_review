import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamer_review/review_card.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';

class ReviewsContainer extends StatefulWidget {
  @override
  _ReviewsContainer createState() => new _ReviewsContainer();
}

class _ReviewsContainer extends State<ReviewsContainer> {
  var oldReview;
  var temp;
  List<ReviewCard> reviewsList = [];

  Future<List<ReviewCard>> getReview() async {
    List<ReviewCard> reviewsList1 = new List<ReviewCard>();
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    oldReview = await d.selectUserReviews();
    if (oldReview != null) {
      for (int i = 0; i < oldReview.length; i++) {
        temp = oldReview[i]["fk_broadcaster_id"];
        ReviewCard reviewCard = new ReviewCard(temp.toString());
        reviewsList1.add(reviewCard);
      }
    }
    if (reviewsList1 != null) {
      setState(() {
        reviewsList = reviewsList1;
      });
    }
    setState((){});
    return reviewsList1;
  }


  @override
  void initState() {
    getReview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getReview();
    return Container(
      height: 1000,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: reviewsList,
      ),
    );
  }
}