import 'package:flutter/material.dart';

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
      body: ReorderableListView(onReorder: onReorder, children: getListItems()),
        backgroundColor: Colors.black45,
    );
  }

  List<SwitchListTile> getListItems() => categories
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
  }
}
