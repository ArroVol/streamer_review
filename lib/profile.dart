import 'package:flutter/material.dart';
import 'package:streamer_review/edit_user_settings.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'customize_home.dart';
import 'helper/database_helper.dart';
import 'custom_route.dart';
import 'login.dart';
import 'model/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:app_settings/app_settings.dart';

/// Create the state for the profile.
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

/// The profile state that populates the user's profile data and settings.
class _ProfileState extends State<Profile> {
  // secure storage to access the user's stored email.
  final SecureStorage secureStorage = SecureStorage();

  final _notifier = ValueNotifier<ThemeModel>(ThemeModel(ThemeMode.light));

  int numOfReviews = 0;
  String userEmail = '';
  String userName = '';
  String phoneNumber = '';

  /// Gets the user's account
  Future<User> getUser() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    String userEmail2 = await d.getUserEmail();
    List<User> userList = await d.getUserByEmail(userEmail2);
    print("in profiles get username....");
    print(userList.first.userName);
    var userName2 = await secureStorage.readSecureData('userName');
    var phoneNumber2 = await secureStorage.readSecureData('phoneNumber');
    return userList.first;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// Refreshes the page
  void _onRefresh() async {
    getNumReviews().then((value) => null);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  /// Gets the number of reviews the user has submitted
  Future<int> getNumReviews() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    var numOfReviews2 = await d.getNumUserReviews();
    var userEmail2 = await d.getUserEmail();
    var userName2 = await secureStorage.readSecureData('userName');
    var phoneNumber2 = await secureStorage.readSecureData('phoneNumber');
    userName = userName2;
    phoneNumber = phoneNumber2;
    if (mounted) {
      setState(() {
        print("in profile set states.");
        numOfReviews = numOfReviews2;
        userEmail = userEmail2;
        userName = userName2;
        phoneNumber = phoneNumber2;
        print(userName);
        print(phoneNumber);
      });
    }
  }

  /// Initalize data to be populated
  @override
  void initState() {
    getNumReviews();
    getUser();
    super.initState();
  }

  // @override
  // Future<void> dispose() async {
  //
  // }

  /// The widget profile.
  @override
  Widget build(BuildContext context) {
    // getNumReviews();

    return ValueListenableBuilder<ThemeModel>(
      valueListenable: _notifier,
      builder: (_, model, __) {
        final mode = model.mode;
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.grey[800],
          ),
          darkTheme: ThemeData.dark(), // Provide dark theme.
          themeMode: mode,
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[850],
              title: Text(
                'STREVIEW',
                style: TextStyle(
                    color: Colors.lightGreenAccent, letterSpacing: 1.5),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            backgroundColor: Colors.black,
            body: Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                  child:  CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 47.0,
                        backgroundImage: AssetImage('assets/gooby.jpg'),
                      ),
                    ),
                  //   child: CircleAvatar(
                  // child: CircleAvatar(
                  //     backgroundImage: AssetImage('assets/gooby.jpg'),
                  //     radius: 40,
                  //   ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 10,
                    color: Colors.grey[400],
                  ),
                  // Text(
                  //   'USERNAME',
                  //   style:
                  //   TextStyle(color: Colors.lightGreenAccent, letterSpacing: 1.5),
                  // ),
                  // SizedBox(height: 10),
                  // Text(
                  //   userName.toString().toUpperCase(),
                  //   style: TextStyle(
                  //     color: Colors.grey[400],
                  //     letterSpacing: 1.5,
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.lightGreenAccent[100],
                      ),
                      SizedBox(width: 20),
                      Text(
                        userName.toString().toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.phone,
                        color: Colors.lightGreenAccent[100],
                      ),
                      SizedBox(width: 20),
                      Text(
                        phoneNumber.toString(),
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Colors.lightGreenAccent[100],
                      ),
                      SizedBox(width: 20),
                      Text(
                        userEmail,
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                            letterSpacing: 1),
                      ),
                    ],
                  ),

                  // Row(
                  //   children: <Widget>[
                  //     Icon(
                  //       Icons.star,
                  //       color: Colors.lightGreenAccent[100],
                  //     ),
                  //     SizedBox(width: 20),
                  //     Text("# OF REVIEWS MADE: " +
                  //         numOfReviews.toString(),
                  //         style: TextStyle(
                  //             color: Colors.grey[400],
                  //             fontSize: 18,
                  //             letterSpacing: 1)),
                  //     SizedBox(height: 10),
                  //   ],
                  // ),
                  Divider(
                    height: 10,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 30),
                  new ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    // alignment: MainAxisAlignment.center,
                    // this will take space as minimum as posible(to center)
                    children: <Widget>[
                      OutlineButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomizeHome()));
                        },
                        child: Container(
                          height: 40,
                          width: 300,
                          color: Colors.grey[850],
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('CUSTOMIZE HOME SCREEN',
                                style: TextStyle(
                                    color: Colors.lightGreenAccent[100],
                                    fontSize: 16,
                                    letterSpacing: 1.5)),
                          ),
                        ),
                      ),
                      OutlineButton(
                        // onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => EditUserSettings()));
                        // },
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditUserSettings()))
                              .then((value) {
                            setState(() {
                              getNumReviews();
                              getUser();
                            });
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 300,
                          color: Colors.grey[850],
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('EDIT USER INFORMATION',
                                style: TextStyle(
                                    color: Colors.lightGreenAccent[100],
                                    fontSize: 16,
                                    letterSpacing: 1.5)),
                          ),
                        ),
                      ),
                      // new ButtonBar(
                      //
                      //   mainAxisSize: MainAxisSize.min,
                      //   // alignment: MainAxisAlignment.center,
                      //   // this will take space as minimum as posible(to center)
                      //   children: <Widget>[
                      OutlineButton(
                        onPressed: () {
                          AppSettings.openAppSettings();
                        },
                        child: Container(
                          height: 40,
                          width: 300,
                          color: Colors.grey[850],
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('VIEW APPLICATION SETTINGS',
                                style: TextStyle(
                                    color: Colors.lightGreenAccent[100],
                                    fontSize: 16,
                                    letterSpacing: 1.5)),
                          ),
                        ),
                      ),
                      OutlineButton(
                        onPressed: () {
                          AppSettings.openNotificationSettings();
                        },
                        child: Container(
                          height: 40,
                          width: 300,
                          color: Colors.grey[850],
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('NOTIFICATION SETTINGS',
                                style: TextStyle(
                                    color: Colors.lightGreenAccent[100],
                                    fontSize: 16,
                                    letterSpacing: 1.5)),
                          ),
                        ),
                      ),

                      // OutlineButton(
                      //   onPressed: () {
                      //     _notifier.value = ThemeModel(
                      //         mode == ThemeMode.light ? ThemeMode.dark : ThemeMode
                      //             .light);
                      //   },
                      //   // padding: EdgeInsets.all(20),
                      //
                      //   child: Container(
                      //     height: 30,
                      //     width: 100,
                      //     // padding: EdgeInsets.all(20),
                      //
                      //     child: Align(
                      //       alignment: Alignment.centerRight,
                      //       child: Text('Toggle Theme',
                      //           style: TextStyle(
                      //               color: Colors.lightGreenAccent[100],
                      //               fontSize: 15,
                      //               // backgroundColor: ThemeData,
                      //               letterSpacing: .1)),
                      //
                      //     ),
                      //   ),
                      // ),

                      // RaisedButton(
                      //   onPressed: () {_notifier.value = ThemeModel(mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light); },
                      //   child: Text('Toggle Theme'),
                      // ),

                      // RaisedButton(
                      //   child: Text("App Settings"),
                      //   onPressed: () {
                      //     AppSettings.openAppSettings();
                      //   },
                      // ),
                    ],
                  ),
                  // OutlineButton(
                  //   onPressed: () {
                  //     AppSettings.openNotificationSettings();
                  //   },
                  //   child: Container(
                  //     height: 40,
                  //     width: 300,
                  //     color: Colors.grey[850],
                  //     child: Align(
                  //       alignment: Alignment.center,
                  //       child: Text('NOTIFICATION SETTINGS',
                  //           style: TextStyle(
                  //               color: Colors.lightGreenAccent[100],
                  //               fontSize: 18,
                  //               letterSpacing: 1.5)),
                  //     ),
                  //   ),
                  // ),
                  //
                  // OutlineButton(
                  //   onPressed: () {
                  //     secureStorage.deleteSecureData('email');
                  //     secureStorage.deleteSecureData('password');
                  //     secureStorage.deleteSecureData('userName');
                  //     secureStorage.deleteSecureData('phoneNumber');
                  //
                  //     Navigator.of(context, rootNavigator: true)
                  //         .pushReplacement(FadePageRoute(
                  //       builder: (context) => new LoginScreen(),
                  //     ));
                  //   },
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     height: 40,
                  //     width: 100,
                  //     color: Colors.grey[850],
                  //     child: Align(
                  //       alignment: Alignment.center,
                  //       child: Text('LOGOUT',
                  //           style: TextStyle(
                  //               color: Colors.lightGreenAccent[100],
                  //               fontSize: 18,
                  //               letterSpacing: 1.5)),
                  //     ),
                  //   ),
                  // ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5.0,
                                ),
                                RaisedButton(
                                    onPressed: () {
                                      secureStorage.deleteSecureData('email');
                                      secureStorage
                                          .deleteSecureData('password');
                                      secureStorage
                                          .deleteSecureData('userName');
                                      secureStorage
                                          .deleteSecureData('phoneNumber');

                                      Navigator.of(context, rootNavigator: true)
                                          .pushReplacement(FadePageRoute(
                                        builder: (context) => new LoginScreen(),
                                      ));
                                    },
                                    elevation: 0.0,
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          color: Colors.lightGreenAccent[100]),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 100.0, minHeight: 40.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "LOGOUT",
                                          style: TextStyle(
                                              color: Colors.grey[850],
                                              letterSpacing: 1.5,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Future _getUserName() async {
//   print("in get");
//   // String email = await secureStorage.readSecureData("email");
//   print(email);
// }

}

class ThemeModel with ChangeNotifier {
  final ThemeMode _mode;

  ThemeMode get mode => _mode;

  ThemeModel(this._mode);
}
