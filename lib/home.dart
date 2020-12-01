import 'package:flutter/material.dart';
import 'package:streamer_review/expansion_row_container.dart';
import 'package:streamer_review/streamer_thumb.dart';
import 'package:streamer_review/push_notifications.dart';
import 'package:streamer_review/search.dart';
import 'package:streamer_review/widgets/anotherMain.dart';

import 'custom_route.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[500],
        appBar: AppBar(
            title: Text(
              'STREVIEW',
              style:
              TextStyle(color: Colors.lightGreenAccent, letterSpacing: 1.5),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.logout),
                alignment: Alignment.centerLeft,
                onPressed: () {
                  secureStorage.deleteSecureData('email');
                  secureStorage.deleteSecureData('password');

                  Navigator.of(context).pushReplacement(FadePageRoute(
                    builder: (context) => LoginScreen(),
                  ));
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                alignment: Alignment.centerLeft,
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchPage());
                  })
            ],
            centerTitle: true,
            backgroundColor: Colors.black54),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      // StreamerThumb(),
                      Text(
                        'Featured Streamer',
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.black38,
              ),
              Text('Favorites'),
              ExpansionTile(
                children: [
                  ExpansionRowContainer(),
                ],
              ),
              Divider(
                color: Colors.black38,
              ),
              Text('Top Rated Streamers'),
              ExpansionTile(
                children: [
                  ExpansionRowContainer(),
                ],
              ),
              Divider(
                color: Colors.black38,
              ),
              Text('Streaming Now'),
              ExpansionTile(
                children: [
                  ExpansionRowContainer(),
                ],
              ),
              Divider(
                color: Colors.black38,
              ),
              Text('Up and Coming'),
              ExpansionTile(
                children: [
                  ExpansionRowContainer(),
                ],
              ),
              Divider(
                color: Colors.black38,
              ),
              Text('Tag - Funny'),
              ExpansionTile(
                children: [
                  ExpansionRowContainer(),
                ],
              ),
              Divider(
                color: Colors.black38,
              ),
              Text('Tag - Competitive'),
              ExpansionTile(
                children: [
                  ExpansionRowContainer(),
                ],
              ),
              Divider(
                color: Colors.black38,
              ),
            ],
          ),
        ));
  }
}

class StreamerSearch extends SearchDelegate<String> {
  final streamerList = [
    'ninja',
    'streamer2',
    'streamer1',
    'streamer4',
    'streamer3',
  ];

  final recentStreamerList = ['ninja'];

  @override
  List<Widget> buildActions(BuildContext context) {
    //what actions will occur
    return [
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icon showing on left
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show results
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = query.isEmpty ? recentStreamerList : streamerList;
    return ListView.builder(
      itemBuilder: (context, index) =>
          ListTile(
            leading: Icon(Icons.gamepad),
            title: Text(searchResults[index]),
          ),
      itemCount: searchResults.length,
    );
  }
}
