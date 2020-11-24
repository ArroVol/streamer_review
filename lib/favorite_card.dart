import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:streamer_review/streamer_screen.dart';

class FavoriteCard extends StatefulWidget {
  @override
  _FavoriteCard createState() => _FavoriteCard();
}

class _FavoriteCard extends State<FavoriteCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 5.0,
      child: new InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StreamerPage('SlyFoxHound')));;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://static-cdn.jtvnw.net/jtv_user_pictures/00d4514a-e300-4f00-8ca9-b6094577af49-profile_image-70x70.png',
                  ),
                  radius: 30.0,
                ),
                title: Text(
                  "SlyFoxHound",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                    ),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 30.0,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      // onRatingUpdate: (rating) {
                      //   // entertainment_rating = rating;
                      //   // print(rating);
                      // },
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.favorite,
                  size: 35.0,
                  color: Colors.deepPurple[800],
                ),
              ),
              // Column(
              //     children: <Widget>[
              //       RatingBar.builder(
              //         initialRating: 3,
              //         minRating: 1,
              //         direction: Axis.horizontal,
              //         allowHalfRating: false,
              //         itemCount: 5,
              //         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //         itemBuilder: (context, _) => Icon(
              //           Icons.star,
              //           color: Colors.amber,
              //         ),
              //         onRatingUpdate: (rating) {
              //           // entertainment_rating = rating;
              //           // print(rating);
              //         },
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
