import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/repository/broadcaster_repository.dart';
import 'package:streamer_review/repository/user_favorites_repository.dart';
import 'package:streamer_review/repository/user_repository.dart';

/// Runs the application
///
void main() {
  runApp(MyApp());
  print(DatabaseHelper2.directoryPath);
}

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

class AaronsMain2 extends StatefulWidget {
  AaronsMain2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

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

            new TextField(
              decoration:
              new InputDecoration.collapsed(hintText: "input broadcaster id"),
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              onSubmitted: (iD) {
                print("Submitted ID:  $iD");
                _setId(int.parse(iD));
              },
            ),
            new TextField(
              decoration:
              new InputDecoration.collapsed(hintText: "input user Id"),
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              onSubmitted: (String userId) {
                print("Submitted:  $userId");
                _setUserId(int.parse(userId));
              },
            ),

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

            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows = await DatabaseHelper2.instance.selectReviews(229729353, 1);
                  print(queryRows);
                },
                child: Text('select reviews')),
            FlatButton(
                onPressed: () async {
                  int queryRows = await DatabaseHelper2.instance.insertReview(5, 5,5,5, 229729353, 1, 1);
                  await DatabaseHelper2.instance.updateBroadcaster(229729353, 1, 1);

                  print(queryRows);
                },
                child: Text('insert reviews')),
            FlatButton(
                onPressed: () async {
                  await DatabaseHelper2.instance.clearReviews();
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
