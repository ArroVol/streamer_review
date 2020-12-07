import 'package:dev_test/dev_test.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/model/user.dart';
import 'package:streamer_review/repository/broadcaster_repository.dart';
import 'package:streamer_review/repository/user_favorites_repository.dart';
import 'package:streamer_review/repository/user_repository.dart';
import 'package:streamer_review/widgets/anotherMain.dart';

import '../main.dart';


void main() {
  runApp(MyApp());

  test('return the database', () async {

    // TestWidgetsFlutterBinding.ensureInitialized();
    // final result = EmailFieldValidator.validate('');
    // expect(result, 'Email can\'t be empty');
    Database db = await DatabaseHelper2.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM broadcaster_table WHERE broadcaster_id=?',
        [2224]);
    print(db.path);
  });

  test('return the database', () async {

    // TestWidgetsFlutterBinding.ensureInitialized();
    // final result = EmailFieldValidator.validate('');
    // expect(result, 'Email can\'t be empty');
    Database db = await DatabaseHelper2.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM broadcaster_table WHERE broadcaster_id=?',
        [2224]);
    // print(db.path);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DB User testing',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AaronsMain()

      // home: ColorCircle(title: 'Color Circle',),
    );
  }
}

class AaronsMain extends StatefulWidget {
  AaronsMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AaronsMain> {
  UserFavoritesRepository _userFavoritesRepository = new UserFavoritesRepository();
  BroadcasterRepository _broadcasterRepository = new BroadcasterRepository();
  UserRepository _userRepository = new UserRepository();
  String _email = "";
  String _password = "";
  String _userName = '';
  int _iD;

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container();
    return Scaffold(
      appBar: AppBar(
        title: Text('Streamer Review'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              decoration:
              new InputDecoration.collapsed(hintText: "input email"),
              // onChanged: (String text) {
              // print("Text => $text");
              // },
              onSubmitted: (email) {
                print("Submitted:  $email");
                _setEmail(email);
              },
            ),
            new TextField(
              decoration:
              new InputDecoration.collapsed(hintText: "input password"),
              // onChanged: (String text) {
              // print("Text => $text");
              // },
              onSubmitted: (String password) {
                print("Submitted:  $password");
                _setPassword(password);
              },
            ),
            new TextField(
              decoration:
              new InputDecoration.collapsed(hintText: "input user Name"),
              // onChanged: (String text) {
              // print("Text => $text");
              // },
              onSubmitted: (String userName) {
                // print("Submitted:  $password");
                // _setPassword(password);
              },
            ),

            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                  await DatabaseHelper2.instance.queryAllUsers();
                  print(queryRows);
                },
                child: Text('query all users')),

            Center(
              child: new TextField(
                decoration:
                new InputDecoration.collapsed(hintText: "Enter an ID to delete"),
                onSubmitted: (iD) {
                  print("Submitted:  $iD");
                  _setId(num.parse(iD));
                },

              ),
            ),
            FlatButton(
                onPressed: () async {
                  int rowsAffected = await DatabaseHelper2.instance.delete(_iD);
                  print(rowsAffected);
                },
                child: Text('delete user')),

            FlatButton(
                onPressed: () async {
                  print("testing pushing email and pass");
                  print(_email);
                  print(_password);
                  DatabaseHelper2.instance.insert({
                    DatabaseHelper2.columnEmail: _email,
                    DatabaseHelper2.columnPassword: _password
                  });
                },
                child: Text('Insert specified email and pass')),
            FlatButton(
                onPressed: () async {;
                User newUser = new User();
                newUser.email = 'newEmail@gmail.com';
                newUser.phoneNumber = '7777777777';
                newUser.userName = 'new user guy';
                newUser.password = 'password123';
                // User returnedUser =
                DatabaseHelper2.instance.insertUser(newUser);
                },
                child: Text('Insert a user object')),
            FlatButton(
                onPressed: () async {
                  secureStorage.deleteSecureData('email');
                  secureStorage.deleteSecureData('password');
                },
                child: Text('Clear Secure Data')),
            FlatButton(
                onPressed: () async {
                  User newUser = new User();
                  newUser.email = 'newEmail2@gmail.com';
                  newUser.phoneNumber = '7777777770';
                  newUser.userName = 'new user guy2';
                  newUser.password = 'password123';
                  DatabaseHelper2.instance.checkUserIntoDatabase(newUser);
                },
                child: Text('insert a user into the database')),
            FlatButton(
                onPressed: () async {
                  int userId = await DatabaseHelper2.instance.getUserIdByUserName('new user guy2');
                  print(userId);
                },
                child: Text('get id by username')),
            FlatButton(
                onPressed: () async {
                  List<User> pulledUser = await DatabaseHelper2.instance.getUserByUserName("new user guy2");
                  print(pulledUser.first.phoneNumber);
                  print(pulledUser.first.id);
                },
                child: Text('get user by username')),

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
  void _setUserName(String userName) {
    setState(() {
      _userName = userName;
    });
  }



}
