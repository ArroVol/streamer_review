import 'package:flutter/material.dart';

class EditUserSettings extends StatefulWidget {
  @override
  _EditUserSettings createState() => _EditUserSettings();
}

class _EditUserSettings extends State<EditUserSettings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit User Settings',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.lightGreenAccent,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 115.0),
                Text(
                  "Username",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 22.0,
                    color: Colors.lightGreenAccent,
                  ),
                ),

                SizedBox(height: 5.0),
                // usernameField,
                SizedBox(height: 15.0),
                SizedBox(height: 15.0),
                Text(
                  "Phone number",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 22.0,
                    color: Colors.lightGreenAccent,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                // confirmPhoneNumber,
                SizedBox(height: 25.0),
                // loginButon,

              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[700],

    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit User Settings',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.lightGreenAccent,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: ReorderableListView(

    )
    );
  }
  List<String> categories = [
    'Gaming',
    'Food & Drinks',
    'Sports & Fitness',
    'Talk Shows & Podcasts',
    'Just Chatting',
    'Makers & Crafting',
    'Tabletop RPGs',
    'Science & Technologies',
    'Music & Performing Arts',
    'Beauty & Body Art'
  ];

}
