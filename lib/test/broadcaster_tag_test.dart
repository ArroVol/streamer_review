import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/main.dart';
import 'package:streamer_review/model/user.dart';
import 'package:streamer_review/repository/broadcaster_repository.dart';
import 'package:streamer_review/repository/user_favorites_repository.dart';
import 'package:streamer_review/repository/user_repository.dart';
import 'package:streamer_review/widgets/anotherMain.dart';

// import 'model/user.dart';

void main() {
  runApp(MyApp());
  print(DatabaseHelper2.directoryPath);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Streamer Review App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container();
    return Scaffold(
      appBar: AppBar(
        title: Text('BROADCASTER TAG TEST'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
                  List<Map<String, dynamic>> queryRows =
                  await DatabaseHelper2.instance.queryAllStreamers();
                  print(queryRows);
                },
                child: Text('query all streamers')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                  await _userFavoritesRepository.queryAllFavorites();
                  print(queryRows);
                },
                child: Text('query all favorites')),

            FlatButton(
                onPressed: () async {
                  await _userFavoritesRepository.insertFavorite(229729353);
                },
                child: Text('insert favorite')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =  await DatabaseHelper2.instance.broadcasterTagRepository.insertBroadcasterTag(222555, 'Gaming', 1);
                  print(queryRows);
                },
                child: Text('insert broadcaster tag')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =  await DatabaseHelper2.instance.broadcasterTagRepository.selectAllTags();
                  print(queryRows);
                },
                child: Text('query all broadcaster tag')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =  await DatabaseHelper2.instance.broadcasterTagRepository.queryAllfromTagNames();
                  print(queryRows);
                },
                child: Text('query all tag names')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =  await DatabaseHelper2.instance.broadcasterTagRepository.selectAllBroadcastersByBroadcasterTag('Gaming');
                  print(queryRows);
                },
                child: Text('select all broadcasters by tag: gaming')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =  await DatabaseHelper2.instance.broadcasterTagRepository.selectAllBroadcasterTagsByBroadcaster(222555);
                  print(queryRows);
                },
                child: Text('query all tags from a broadcaster')),
            FlatButton(
                onPressed: () async {
                  String email =  await secureStorage.readSecureData('email');
                },
                child: Text('check whats in secure storage')),
          ],
        ),
      ),
    );
  }

  void _setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void _setId(int iD){
    setState(() {
      _iD = iD;
    });
  }

  void _setPassword(String password) {
    setState(() {
      _password = password;
    });
  }

}