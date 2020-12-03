import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamer_review/streamer_screen.dart';

class FeaturedStreamer extends StatefulWidget {
  @override
  _FeaturedStreamerState createState() => _FeaturedStreamerState();
}

class _FeaturedStreamerState extends State<FeaturedStreamer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      elevation: 10,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(),
      child: new InkWell(
        onTap: () {
          print("Featured Streamer clicked");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => StreamerPage('ninja')));
        },
        child: Container(
          height: 290,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Featured Streamer',
                  style:
                      TextStyle(color: Colors.lightGreenAccent, fontSize: 18, letterSpacing: 1.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ninja',
                  style:
                      TextStyle(color: Colors.lightGreenAccent, fontSize: 24),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 180,
                      width: 180,
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        heightFactor: 1,
                        child: Image(
                          image: AssetImage('assets/example.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text('Description Placeholder'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
