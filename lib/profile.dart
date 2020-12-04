import 'package:flutter/material.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {
  // final SecureStorage secureStorage = SecureStorage();
  String email ='';

  void initState() {
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
                  '$email',
                  style:TextStyle(
                      color: Colors.lightGreenAccent[100],
                      fontSize: 18,
                      letterSpacing: 1
                  ),

                ),
                CheckboxListTile(
                  value: true,
                  title: Text("This is a CheckBoxPreference"),
                  onChanged: (value) {

                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _getUserName() async {
    print("in get");
    // String email = await secureStorage.readSecureData("email");
    print(email);
  }

}
