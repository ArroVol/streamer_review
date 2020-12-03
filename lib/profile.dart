import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int numOfReviews;

  Future<int> getNumReviews() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    numOfReviews = await d.getNumUserReviews();
  }

  @override
  Widget build(BuildContext context) {
    getNumReviews();
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
            SizedBox(width: 20),
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
                  style: TextStyle(
                      color: Colors.lightGreenAccent[100],
                      fontSize: 18,
                      letterSpacing: 1),
                ),
                // SizedBox(width: 20),
                // Text("Number of Reviews made: " + numOfReviews.toString())
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
          ],
        ),
      ),
    );
  }
}
