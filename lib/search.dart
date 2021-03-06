import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamer_review/search_container.dart';
import 'package:streamer_review/streamer.dart';
import 'package:http/http.dart' as http;
import 'package:streamer_review/streamer_screen.dart';

import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';
import 'model/broadcaster_from_db.dart';

class SearchPage extends SearchDelegate<String> {
  var data;
  var topStreamerInfo;
  Streamer topStreamer;
  List<String> streamerList = [];

  List<String> streamerList2 = [];
  List countries = [];
  List filteredCountries = [];
  bool isSearching = false;

  var selection;
  var recentSearchList = [];
  bool offline = false;


  Future<List> getStreamers() async {
    // var url = 'https://api.twitch.tv/helix/streams?user_id=' + query + '&?first=10';
    var url = 'https://api.twitch.tv/helix/search/channels?query=' +
        query +
        '&?first=5';
    // print(url);
    http.Response response = await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });
    streamerList.clear();
    streamerList2.clear();
    data = json.decode(response.body);

    if (data['data'].length > 0) {
      for (int i = 0; i < data['data'].length; i++) {
        streamerList.add(data['data'][i]['display_name']);
        streamerList2.add(data['data'][i]['id'].toString());
      }
      print(streamerList);
    }
    return streamerList;
  }

  Future<List> getter() async {
    var list = await getStreamers();
    streamerList = list;
    return streamerList;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.grey[850],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //what actions will occur
    return [
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            query = '';
            // print(query);
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
  // ignore: missing_return
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      recentSearchList.add(query);
      recentSearchList = new List.from(recentSearchList .reversed);
    }
    return FutureBuilder(
        builder: (context, projectSnap) {
          // if (projectSnap.connectionState == ConnectionState.none &&
          //     projectSnap.hasData == null) {
          //   //print('project snapshot data is: ${projectSnap.data}');
          //   return Container();
          // }
          return ListView.builder(
            itemBuilder: (context, index) => Container(
              child: SearchContainer(streamerList2),
            ),
            itemCount: streamerList.length,
          );
        },
        future: getStreamers());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = query.isEmpty ? recentSearchList : streamerList;
    return FutureBuilder(
      builder: (context, projectSnap) {
        // if (projectSnap.connectionState == ConnectionState.none &&
        //     projectSnap.hasData == null) {
        //   //print('project snapshot data is: ${projectSnap.data}');
        //   return Container();
        // }
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              selection = searchResults[index];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StreamerPage(selection)));
              // streamerList = searchResults;
            },
            leading: Icon(Icons.gamepad),
            title: Text(searchResults[index]),
          ),
          itemCount: searchResults.length,
        );
      },
      future: getStreamers(),
    );
  }
}
