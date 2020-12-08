import 'package:flutter/material.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'customize_home.dart';
import 'helper/database_helper.dart';
import 'custom_route.dart';
import 'login.dart';
import 'model/user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final SecureStorage secureStorage = SecureStorage();

  int numOfReviews = 0;
  String userEmail = '';
  String userName = '';
  String phoneNumber = '';

  void getUser() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    String userEmail2 = await d.getUserEmail();
    List<User> userList = await d.getUserByEmail(userEmail2);
    print("in profiles get username....");
    print(userList.first.userName);
  }

  Future<int> getNumReviews() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    var numOfReviews2 = await d.getNumUserReviews();
    var userEmail2 = await d.getUserEmail();
    var userName2 = await secureStorage.readSecureData('userName');
    var phoneNumber2 = await secureStorage.readSecureData('phoneNumber');
    if (mounted) {
      setState(() {
        numOfReviews = numOfReviews2;
        userEmail = userEmail2;
        userName = userName2;
        phoneNumber = phoneNumber2;
        print(userName);
        print(phoneNumber);
      });
    }
  }

  @override
  void initState() {
    getNumReviews();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[500],
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/gooby.jpg'),
                radius: 40,
              ),
            ),
            Divider(
              height: 60,
              color: Colors.grey[800],
            ),
            Text(
              'User Name',
              style: TextStyle(color: Colors.blueGrey, letterSpacing: 2.0),
            ),
            SizedBox(height: 10),
            Text(
              userName.toString(),
              style: TextStyle(
                color: Colors.lightGreenAccent,
                letterSpacing: 2.0,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              height: 10,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              'Phone Number',
              style: TextStyle(color: Colors.blueGrey, letterSpacing: 2.0),
            ),
            SizedBox(height: 10),
            Text(
              phoneNumber.toString(),
              style: TextStyle(
                color: Colors.lightGreenAccent,
                letterSpacing: 2.0,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 20),
                Text(
                  userEmail,
                  style: TextStyle(
                      color: Colors.lightGreenAccent[100],
                      fontSize: 18,
                      letterSpacing: 1),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 20),
                Text("Number of Reviews made: " + numOfReviews.toString(),
                    style: TextStyle(
                        color: Colors.lightGreenAccent[100],
                        fontSize: 18,
                        letterSpacing: 1)),
                SizedBox(height: 10),
              ],
            ),
            OutlineButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomizeHome()));
              },
              child: Container(
                height: 30,
                width: 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Customize',
                      style: TextStyle(
                          color: Colors.lightGreenAccent[100],
                          fontSize: 18,
                          letterSpacing: 1)),
                ),
              ),
            ),
            OutlineButton(
              onPressed: () {
                secureStorage.deleteSecureData('email');
                secureStorage.deleteSecureData('password');
                secureStorage.deleteSecureData('userName');
                secureStorage.deleteSecureData('phoneNumber');

                Navigator.of(context, rootNavigator: true)
                    .pushReplacement(FadePageRoute(
                  builder: (context) => new LoginScreen(),
                ));
              },
              child: Container(
                height: 30,
                width: 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Logout',
                      style: TextStyle(
                          color: Colors.lightGreenAccent[100],
                          fontSize: 18,
                          letterSpacing: 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Future _getUserName() async {
//   print("in get");
//   // String email = await secureStorage.readSecureData("email");
//   print(email);
// }

}
