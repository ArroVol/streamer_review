import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/model/broadcaster.dart';
import 'package:streamer_review/model/user.dart';
import 'package:streamer_review/repository/broadcaster_repository.dart';
import 'package:streamer_review/repository/user_favorites_repository.dart';
import 'package:streamer_review/repository/user_repository.dart';

/// Entry point to the braodcaster test page.
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
        title: 'Streamer Review App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
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
              new InputDecoration.collapsed(hintText: "input broadcaster name"),
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              onSubmitted: (String password) {
                print("Submitted:  $password");
                _setPassword(password);
              },
            ),

            /// Test 1
            ///
            /// querying all boradcasters from the database.
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                  await DatabaseHelper2.instance.selectAllBroadcasters();
                  print(queryRows);
                  List<Broadcaster> userList = [];
                  List.generate(1, (i) {
                    userList.add(Broadcaster(
                      // id: queryRows[i]['_id'],
                      broadcasterName: queryRows[i]['broadcaster_name'],
                      // password: queryRows[i]['password'],
                      // userName: queryRows[i]['user_name'],
                      // phoneNumber: queryRows[i]['phone_number'],
                    )
                    );
                  });
                 // print(userList.first.broadcasterName);
                assert(userList.first.broadcasterName == 'nickmercs');
                  },
                child: Text('query all broadcasters')),
            /// Test 2
            ///
            /// querying all users from the database.
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> user =
                  await DatabaseHelper2.instance.queryAllUsers();
                  print(user);
                  print(DatabaseHelper2.directoryPath);
                  List<User> userList = [];
                  List.generate(user.length, (i) {
                    userList.add(User(
                      id: user[i]['_id'],
                      email: user[i]['email'],
                      password: user[i]['password'],
                      userName: user[i]['user_name'],
                      phoneNumber: user[i]['phone_number'],
                    ));
                  });
                  int id = userList.first.id;
                  // print(userList.first.broadcasterName);
                  assert(userList.first.email == "bnew@gmail.com");
                },
                child: Text('query all users')),

            /// Test 3
            ///
            /// updating the broadcaster
            FlatButton(
                onPressed: () async {
                  await DatabaseHelper2.instance.updateBroadcaster(229729353, 1, 1);
                },
                child: Text('update broadcaster')),
            /// Test 4
            ///
            /// inserting the broadcaster
            FlatButton(
                onPressed: () async {

                  int result = await DatabaseHelper2.instance.broadcasterRepository.insertBroadcaster(0, 0, 0, 0, _iD);
                assert(result != 0);
                },
                child: Text('insert new broadcaster ')),
            /// Test 5
            ///
            /// testing insert fail when the broadcaster already exists in the database.
            FlatButton(
                onPressed: () async {
                int result =  await DatabaseHelper2.instance.broadcasterRepository.insertBroadcaster(0, 0, 0, 0, 15564828);
               assert(result == 0);
                },
                child: Text('attempt insert broadcaster that already exists ')),
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
