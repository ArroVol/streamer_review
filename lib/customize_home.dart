import 'package:flutter/material.dart';

class CustomizeHome extends StatefulWidget {
  @override
  _CustomizeHomeState createState() => _CustomizeHomeState();
}

class _CustomizeHomeState extends State<CustomizeHome> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customize',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.lightGreenAccent,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: ReorderableListView(
          onReorder: onReorder,
          children: getListItems()),
    );
  }

  List<ListTile> getListItems() => categories
      .asMap()
      .map((index, item) => MapEntry(index, buildTenableListTile(item, index)))
      .values
      .toList();

  ListTile buildTenableListTile(String item, int index) => ListTile(
        key: ValueKey(item),
        title: Text(item),
        leading: Text("#${index + 1}"),
      );

  void onReorder(int oldIndex, int newIndex){
    if(newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState((){
      String category = categories[oldIndex];

      categories.removeAt(oldIndex);
      categories.insert(newIndex, category);
    });
  }
}
