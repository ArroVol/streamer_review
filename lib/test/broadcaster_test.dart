import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/model/broadcaster.dart';
import 'package:streamer_review/model/user.dart';
import 'package:streamer_review/repository/broadcaster_repository.dart';
import 'package:streamer_review/repository/user_favorites_repository.dart';
import 'package:streamer_review/repository/user_repository.dart';

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


            FlatButton(
                onPressed: () async {
                  await DatabaseHelper2.instance.updateBroadcaster(229729353, 1, 1);
                },
                child: Text('update broadcaster')),

            FlatButton(
                onPressed: () async {

                  int result = await DatabaseHelper2.instance.broadcasterRepository.insertBroadcaster(0, 0, 0, 0, _iD);
                assert(result != 0);
                },
                child: Text('insert new broadcaster ')),
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
