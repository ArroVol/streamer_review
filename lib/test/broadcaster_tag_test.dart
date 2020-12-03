import 'package:flutter/material.dart';
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
        title: Text('BROADCASTER TAG TEST'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 215.0),
            // Text(
            //   "Username",
            //   style: TextStyle(
            //     color: Colors.deepPurple,
            //     fontSize: 22.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            new TextField(
              decoration:
              new InputDecoration.collapsed(hintText: "input email"),
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
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
            // FlatButton(
            //     onPressed: () async {
            //       int i = await DatabaseHelper2.instance.insert({
            //         DatabaseHelper2.columnEmail: 'sarah@spoopmail.net',
            //         DatabaseHelper2.columnPassword: 'spoopy9r'
            //       });
            //       print('the inserted id is $i');
            //     },
            //     child: Text('insert')),
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
            // FlatButton(
            //     onPressed: () async {
            //       DatabaseHelper2.instance.resetDb();
            //     },
            //     child: Text('Reset Table')),
            // FlatButton(
            //     onPressed: () async {
            //       DatabaseHelper2.instance.createUserTable();
            //     },
            //     child: Text('Recreate user table')),
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
                  // List<Map<String, dynamic >> user = await DatabaseHelper2.instance.retrieveUserById(1);
                  // print(user.toString());
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
            FlatButton(
                onPressed: () async {
                  await _userFavoritesRepository.insertFavorite(229729353);
                },
                child: Text('insert favorite')),
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
