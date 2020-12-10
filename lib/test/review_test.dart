import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/model/review.dart';
import 'package:streamer_review/repository/broadcaster_repository.dart';
import 'package:streamer_review/repository/user_favorites_repository.dart';
import 'package:streamer_review/repository/user_repository.dart';
import 'package:streamer_review/model/user.dart';

/// Runs the application
///
void main() {
  runApp(MyApp());
  print(DatabaseHelper2.directoryPath);
}
/// The class creates the widget for the test page
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'REVIEW TEST PAGE',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AaronsMain2()

    );
  }
}
/// Creates the my home page state for testing.
class AaronsMain2 extends StatefulWidget {
  AaronsMain2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
/// This class gets the repositories as well as creates the variables.
class _MyHomePageState extends State<AaronsMain2> {
  UserFavoritesRepository _userFavoritesRepository = new UserFavoritesRepository();
  BroadcasterRepository _broadcasterRepository = new BroadcasterRepository();
  UserRepository _userRepository = new UserRepository();
  String _email = "";
  String _password = "";

  int _iD;
  int _userId;
  int _broadcasterId;

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container();
    return Scaffold(
      appBar: AppBar(
        title: Text('REVIEW TEST'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                  await DatabaseHelper2.instance.selectAllBroadcasters();
                  print(queryRows);
                },
                child: Text('query all broadcasters')),

            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                  await DatabaseHelper2.instance.queryAllUsers();
                  print(queryRows);
                  print(DatabaseHelper2.directoryPath);
                },
                child: Text('query all users')),
            /// Test 1
            ///
            /// querying all reviews from the database.
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> user = await DatabaseHelper2.instance.selectReviews(229729353, 1);
                  print(user);
                  List<Review> reviewList = [];
                  List.generate(user.length, (i) {
                    reviewList.add(Review(
                      reviewId: user[i]['reviews_id'],
                      satisfactionRating: user[i]['satisfaction_rating'],
                      broadcasterId: user[i]['fk_broadcaster_id'],
                      userId: user[i]['fk_user_id'],
                    ));
                  });
                  print(reviewList[0].broadcasterId);
                  assert(reviewList[0].broadcasterId == 229729353);
                  assert(reviewList[0].userId == 1);
                  List<User> user2 = await DatabaseHelper2.instance.userRepository.getUserById(1);
                  print(user2.first.userName);
                  assert(user2.first.userName == 'bnew@gmail.com');
                },
                child: Text('select reviews')),
            /// Test 2
            ///
            /// inserting reviews
            FlatButton(
                onPressed: () async {
                  int queryRows = await DatabaseHelper2.instance.insertReview(5, 5,5,5, 229729353, 1, 1);
                  await DatabaseHelper2.instance.updateBroadcaster(229729353, 1, 1);

                  print(queryRows);
                },
                child: Text('insert reviews')),
            /// Test 3
            ///
            /// clearing reviews
            FlatButton(
                onPressed: () async {
                  await DatabaseHelper2.instance.clearReviews();
                  List<Map<String, dynamic>> user = await DatabaseHelper2.instance.selectReviews(229729353, 1);
                  assert(user.length == 0);
                },
                child: Text('clear reviews')),
            FlatButton(
                onPressed: () async {
                  await DatabaseHelper2.instance.updateBroadcaster(229729353, 1, 1);
                },
                child: Text('update broadcaster')),
            FlatButton(
                onPressed: () async {
                  await DatabaseHelper2.instance.broadcasterRepository.insertBroadcaster(0, 0, 0, 0, 55555);
                },
                child: Text('insert broadcaster ')),
          ],

        ),
      ),
    );
  }


  void _setId(int iD){
    setState(() {
      _iD = iD;
    });
  }

  void _setUserId(int userId){
    setState(() {
      _userId = userId;
    });
  }


}
