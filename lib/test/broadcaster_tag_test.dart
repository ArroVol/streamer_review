import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/main.dart';
import 'package:streamer_review/model/broadcaster_tag.dart';
import 'package:streamer_review/model/user.dart';
import 'package:streamer_review/repository/broadcaster_repository.dart';
import 'package:streamer_review/repository/user_favorites_repository.dart';
import 'package:streamer_review/repository/user_repository.dart';

/// Entry point to the braodcaster tag test page.
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
  String _tagName = "";

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
              new InputDecoration.collapsed(hintText: "input tag name"),
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              onSubmitted: (iD) {
                print("Submitted tag nmame: $iD");
                _setTagName(iD);
              },
            ),
            /// Test 1
            ///
            /// querying all users from the database.
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> user =
                  await DatabaseHelper2.instance.queryAllUsers();
                  print(user);
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
            /// Test 2
            ///
            /// querying all broadcasters from the database.
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                  await DatabaseHelper2.instance.queryAllStreamers();
                  print(queryRows);
                },
                child: Text('query all streamers')),
            /// Test 3
            ///
            /// testing insert
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> user = await DatabaseHelper2.instance.broadcasterTagRepository.insertBroadcasterTag(_iD,_tagName, 1);
                  print(user);
                  if(user == null) {
                    List<BroadcasterTag> userList = [];
                    List.generate(user.length, (i) {
                      userList.add(BroadcasterTag(
                        id: user[i]['tags_id'],
                        tagName: user[i]['fk_tag_name'],
                        broadcasterId: user[i]['fk_broadcaster_id'],
                        userId: user[i]['fk_user_id'],
                      ));
                    });
                    print(userList[4].tagName);
                    assert(userList[4].tagName == 'Gaming');
                    assert(userList[4].broadcasterId == 20711821);
                  }
                },
                child: Text('insert broadcaster tag')),
            /// Test 4
            ///
            /// querying all tags
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> user =  await DatabaseHelper2.instance.broadcasterTagRepository.selectAllTags();
                  print(user);
                  List<BroadcasterTag> userList = [];
                  List.generate(user.length, (i) {
                    userList.add(BroadcasterTag(
                      id: user[i]['tags_id'],
                      tagName: user[i]['fk_tag_name'],
                      broadcasterId: user[i]['fk_broadcaster_id'],
                      userId: user[i]['fk_user_id'],
                    ));
                  });
                  print(userList[4].tagName);
                  assert(userList[4].tagName == 'Gaming');
                  assert(userList[4].broadcasterId == 20711821);
                },
                child: Text('query all broadcaster tag')),
            /// Test 5
            ///
            /// querying all tag names
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =  await DatabaseHelper2.instance.broadcasterTagRepository.queryAllfromTagNames();
                  print(queryRows);
                },
                child: Text('query all tag names')),
            /// Test 6
            ///
            /// querying all braodcasters by tags
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> user=  await DatabaseHelper2.instance.broadcasterTagRepository.selectAllBroadcastersByBroadcasterTag('Just Chatting');
                  print(user);
                  List<BroadcasterTag> userList = [];
                  List.generate(user.length, (i) {
                    userList.add(BroadcasterTag(
                      id: user[i]['tags_id'],
                      tagName: user[i]['fk_tag_name'],
                      broadcasterId: user[i]['fk_broadcaster_id'],
                      userId: user[i]['fk_user_id'],
                    ));
                  });
                  print(userList[0].tagName);
                  assert(userList[0].broadcasterId == 20711821);
                },
                child: Text('select all broadcasters by tag: gaming')),
            /// Test 7
            ///
            /// querying all tags by broadcasters
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> user =  await DatabaseHelper2.instance.broadcasterTagRepository.selectAllBroadcasterTagsByBroadcaster(20711821);
                  print(user);
                  List<BroadcasterTag> userList = [];
                  List.generate(user.length, (i) {
                    userList.add(BroadcasterTag(
                      id: user[i]['tags_id'],
                      tagName: user[i]['fk_tag_name'],
                      broadcasterId: user[i]['fk_broadcaster_id'],
                      userId: user[i]['fk_user_id'],
                    ));
                  });
                  print(userList[0].tagName);
                  assert(userList[0].tagName == 'Gaming');
                  assert(userList[1].tagName == 'Just Chatting');

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

  void _setTagName(String tagName){
    setState(() {
      _tagName = tagName;
    });
  }

  void _setPassword(String password) {
    setState(() {
      _password = password;
    });
  }

}
