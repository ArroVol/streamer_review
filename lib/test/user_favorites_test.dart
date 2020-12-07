import 'package:flutter/material.dart';
import 'package:streamer_review/helper/DatabaseHelper.dart';
import 'package:streamer_review/helper/database_helper.dart';
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
        title: Text('BROADCASTER TEST'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            new TextField(
              decoration:
              new InputDecoration.collapsed(hintText: "input favorite broadcaster id"),
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
              onSubmitted: (iD) {
                print("Submitted ID:  $iD");
                _setId(int.parse(iD));
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
                  if(secureStorage.readSecureData('email') == null) {
                    secureStorage.writeSecureData(
                        "email", "goobytest@gmail.com");
                  }
                  await DatabaseHelper2.instance.insertFavorite(_iD);
                },
                child: Text('insert favorite')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows = await DatabaseHelper2.instance.queryAllFavorites();
                  print(queryRows);
                },
                child: Text('query favorite')),
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
                  List<Map<String, dynamic>> queryRows = await DatabaseHelper2.instance.queryAllFavorites();
                  print(queryRows);
                },
                child: Text('query all favorites')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows = await DatabaseHelper2.instance.userFavoritesRepository.queryAllFavoritesByUserLoggedIn();
                  print(queryRows);
                },
                child: Text('query all favorites by user')),

            FlatButton(
                onPressed: () async {
                  await DatabaseHelper2.instance.broadcasterRepository.insertBroadcaster(0, 0, 0, 0, 555);
                },
                child: Text('insert broadcaster ')),
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
