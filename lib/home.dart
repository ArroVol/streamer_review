import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamer_review/expansion_row_container.dart';
import 'package:streamer_review/streamer_thumb.dart';
import 'package:streamer_review/push_notifications.dart';
import 'package:streamer_review/search.dart';
import 'package:streamer_review/widgets/anotherMain.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'category.dart';
import 'custom_route.dart';
import 'featuredStreamer.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> listOfWidgets = new List<Widget>();
  List<Category> categoryList = new List<Category>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    getList().then(updateCategoryList);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    getList().then(updateCategoryList);
  }

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
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchPage());
                  })
            ],
            centerTitle: true,
            backgroundColor: Colors.black54),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: uniqueUserDisplay(),
              // children: <Widget>[
              //   FeaturedStreamer(),
              //   Divider(
              //     height: 10,
              //     color: Colors.black38,
              //   ),
              //   Text('Favorites'),
              //   ExpansionTile(
              //     trailing: Icon(Icons.add_sharp),
              //     children: [
              //       ExpansionRowContainer(),
              //     ],
              //   ),
              //   Divider(
              //     color: Colors.black38,
              //   ),
              //   Text('Top Rated Streamers'),
              //   ExpansionTile(
              //     children: [
              //       ExpansionRowContainer(),
              //     ],
              //   ),
              //   Divider(
              //     color: Colors.black38,
              //   ),
              //   Text('Streaming Now'),
              //   ExpansionTile(
              //     children: [
              //       ExpansionRowContainer(),
              //     ],
              //   ),
              //   Divider(
              //     color: Colors.black38,
              //   ),
              //   Text('Up and Coming'),
              //   ExpansionTile(
              //     children: [
              //       ExpansionRowContainer(),
              //     ],
              //   ),
              //   Divider(
              //     color: Colors.black38,
              //   ),
              //   Text('Tag - Funny'),
              //   ExpansionTile(
              //     children: [
              //       ExpansionRowContainer(),
              //     ],
              //   ),
              //   Divider(
              //     color: Colors.black38,
              //   ),
              //   Text('Tag - Competitive'),
              //   ExpansionTile(
              //     children: [
              //       ExpansionRowContainer(),
              //     ],
              //   ),
              //   Divider(
              //     color: Colors.black38,
              //   ),
              // ],
            ),
          ),
        ));
  }

  List<Widget> uniqueUserDisplay() {
    List<Widget> list = new List<Widget>();
    list.add(FeaturedStreamer());
    list.add(Divider(color: Colors.black45));
    for (Category c in categoryList) {
      if (c.selected) {
        list.add(Text(c.category));
        list.add(ExpansionTile(
          children: [ExpansionRowContainer()],
        ));
        // list.add(Divider(color: Colors.black45));
      }
      print(c.category);
      print(c.selected);
    }
    // String categories = getList();

    return list;
  }

  Future<String> getList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String response = sharedPreferences.getString('categories');
    if (response == null){
      createPreferences();
      response = sharedPreferences.getString('categories');
    }
    return response;
  }

  static List<Category> decode(String toDecodeCategories) =>
      (json.decode(toDecodeCategories) as List<dynamic>)
          .map<Category>((item) => Category.fromJson(item))
          .toList();

  void updateCategoryList(String categoriesString) {
    setState(() {
      this.categoryList = decode(categoriesString);
    });
  }

  void createPreferences() async {
    List<Category> categories = [
      new Category('Favorites', true),
      new Category('Random', true),
      new Category('Gaming', true),
      new Category('Food & Drinks', true),
      new Category('Sports & Fitness', true),
      new Category('Talk Shows & Podcasts', true),
      new Category('Just Chatting', true),
      new Category('Makers & Crafting', true),
      new Category('Tabletop RPGs', true),
      new Category('Science & Technologies', true),
      new Category('Music & Performing Arts', true),
      new Category('Beauty & Body Art', true)
    ];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String encodedCategories = encode(categories);
    sharedPreferences.setString('categories', encodedCategories);
  }

  static String encode(List<Category> listOfCategories) => json.encode(
        listOfCategories
            .map<Map<String, dynamic>>((category) => Category.toMap(category))
            .toList(),
      );
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
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.gamepad),
        title: Text(searchResults[index]),
      ),
      itemCount: searchResults.length,
    );
  }
}
