import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamer_review/streamer_screen.dart';

import 'category.dart';

class CustomizeHome extends StatefulWidget {
  @override
  _CustomizeHomeState createState() => _CustomizeHomeState();
}

class _CustomizeHomeState extends State<CustomizeHome> {
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

  List<SwitchListTile> categoryList = new List<SwitchListTile>();

  @override
  void initState() {
    getList().then(updateCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customize Home Screen',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.lightGreenAccent,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: ReorderableListView(onReorder: onReorder, children: categoryList),
      backgroundColor: Colors.black45,
    );
  }

  // List<SwitchListTile> getListItems()  {
  //   getList().then(updateList())
  //   return buildList();
  // }

  List<SwitchListTile> buildList() => categories
      .asMap()
      .map((index, item) => MapEntry(index, buildTenableListTile(item, index)))
      .values
      .toList();

  SwitchListTile buildTenableListTile(Category category, int index) =>
      SwitchListTile(
        key: ValueKey(category.category),
        title: Text(
          category.category,
          style: TextStyle(
            color: Colors.lightGreenAccent,
          ),
        ),
        activeColor: Colors.lightGreenAccent,
        value: category.selected,
        onChanged: (bool value) {
          setState(() {
            category.selected = value;
          });
          refresh();
        },
      );

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      Category category = categories[oldIndex];
      categories.removeAt(oldIndex);
      categories.insert(newIndex, category);
    });
    refresh();
  }

  static String encode(List<Category> listOfCategories) => json.encode(
    listOfCategories
        .map<Map<String, dynamic>>((category) => Category.toMap(category))
        .toList(),
  );

  static List<Category> decode(String toDecodeCategories) =>
      (json.decode(toDecodeCategories) as List<dynamic>)
          .map<Category>((item) => Category.fromJson(item))
          .toList();

  Future<bool> saveList() async {
    print('Saving Categories');
    String encodedCategories = encode(categories);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('categories', encodedCategories);
  }

  Future<String> getList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('categories');
  }

  void updateCategories(String categoriesString) {
    setState(() {
      print(categoriesString);
      this.categories = decode(categoriesString);
      categoryList = buildList();
      print('here');
    });
  }

  void refresh() {
    saveList();
    getList().then(updateCategories);
  }
}
// import 'package:flutter/material.dart';
//
// class CustomizeHome extends StatefulWidget {
//   @override
//   _CustomizeHomeState createState() => _CustomizeHomeState();
// }
//
// class _CustomizeHomeState extends State<CustomizeHome> {
//   List<String> categories = [
//     'Gaming',
//     'Food & Drinks',
//         'Sports & Fitness',
//     'Talk Shows & Podcasts',
//     'Just Chatting',
//     'Makers & Crafting',
//     'Tabletop RPGs',
//     'Science & Technologies',
//     'Music & Performing Arts',
//     'Beauty & Body Art'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Customize',
//           style: TextStyle(
//             letterSpacing: 1.5,
//             color: Colors.lightGreenAccent,
//           ),
//         ),
//         backgroundColor: Colors.black54,
//       ),
//       body: ReorderableListView(
//           onReorder: onReorder,
//           children: getListItems()),
//     );
//   }
//
//   List<ListTile> getListItems() => categories
//       .asMap()
//       .map((index, item) => MapEntry(index, buildTenableListTile(item, index)))
//       .values
//       .toList();
//
//   ListTile buildTenableListTile(String item, int index) => ListTile(
//         key: ValueKey(item),
//         title: Text(item),
//         leading: Text("#${index + 1}"),
//       );
//
//   void onReorder(int oldIndex, int newIndex){
//     if(newIndex > oldIndex) {
//       newIndex -= 1;
//     }
//     setState((){
//       String category = categories[oldIndex];
//
//       categories.removeAt(oldIndex);
//       categories.insert(newIndex, category);
//     });
//   }
// }
