import 'package:flutter/material.dart';
import 'package:streamer_review/widgets/anotherMain.dart';

import 'custom_route.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('User'),
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
                backgroundImage: AssetImage('assets/example.jpg'),
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
              'ExampleUser1234',
              style: TextStyle(
                color: Colors.lightGreenAccent,
                letterSpacing: 2.0,
                fontSize: 28,
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
                  'test@gmail.com',
                  style:TextStyle(
                      color: Colors.lightGreenAccent[100],
                      fontSize: 18,
                      letterSpacing: 1
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            OutlineButton(onPressed: () {
              secureStorage.deleteSecureData('email');
              secureStorage.deleteSecureData('password');

              Navigator.of(context).pushReplacement(FadePageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
            child: Text('Logout',
            style: TextStyle(
                color: Colors.lightGreenAccent[100],
                fontSize: 18,
                letterSpacing: 1
            )),
            )
          ],
        ),
      ),
    );
  }
}
