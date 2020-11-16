import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/secondScreen.dart';
import 'package:streamer_review/widgets/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streamer Review'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () async {
                  int i = await DatabaseHelper2.instance
                      .insert({DatabaseHelper2.columnName: 'Saheb'});
                  print('the inserted id is $i');
                },
                child: Text('insert')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                  await DatabaseHelper2.instance.queryAll();
                  print(queryRows);
                },
                child: Text('query')),
            FlatButton(
                onPressed: () async {
                  int updatedId = await DatabaseHelper2.instance.update({
                    DatabaseHelper2.columnId: 12,
                    DatabaseHelper2.columnName: 'Mark'
                  });
                  //returns the number of rows affected
                  print(updatedId);
                },
                child: Text('update')),
            FlatButton(onPressed: () async {
              int rowsAffected = await DatabaseHelper2.instance.delete(13);
              print(rowsAffected);
                  }, child: Text('delete')),
          ],
        ),
      ),
    );
  }
}
