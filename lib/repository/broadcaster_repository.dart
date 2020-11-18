import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/model/broadcaster.dart';

class BroadcasterRepository  {

  // final Dio _dio;
  static final _dbName = 'myDatabase.db';

  static final _dbVersion = 1;
  static final _tableName = 'broadcaster';

  // int is used to make all id values unique since they are auto incremented by 1
  Future<int> insert(Map<String, dynamic> row) async {
    //we need to get the database first
    // calls the get database method above
    Database db = await DatabaseHelper2.instance.database;
    //returns the primary key (unique id)

    // final textBroadcaster = Broadcaster(
    //   id: 0,
    //   email: 'Gooby4Ever',
    //   password: 'YeetBois',
    // );
    //
    //
    // var res = await db.insert(_tableName, textBroadcaster.toJson(),
    //     conflictAlgorithm: ConflictAlgorithm.replace);
    return await db.insert(_tableName, row);
  }

  //Query returns a list of map (must be passed as a type)
  //All data will be in the form of map, so it returns a list of map
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.query(_tableName);
  }

  // //to update you need to pass the id of which will be updated as well as pass the value
  // // takes in a map type parameter
  // Future<int> update(Map<String, dynamic> row) async {
  //   print("in the update method in the database");
  //   print(row);
  //   Database db = await DatabaseHelper2.instance.database;
  //   int id = row[columnId];
  //
  //   //This will update the specific row
  //   //first question mark will be replaced by 1, second question mark will be replaced by saheb
  //   return await db.update(_tableName, row,
  //       where: '$columnId = ?',  whereArgs: [id]);
  //   //await because this will take some time
  // }
  //
  // //delete the record that has that id
  // Future<int> delete(int id) async {
  //   print('deleting...');
  //   print(id);
  //   Database db = await DatabaseHelper2.instance.database;
  //   return await db.delete(_tableName,
  //       where: '$columnId = ?', whereArgs: [id]);
  // }
  //
  // Future<List<Broadcaster>> retrieveBroadcasters() async {
  //   Database db = await DatabaseHelper2.instance.database;
  //
  //   final List<Map<String, dynamic>> maps = await db.query(Broadcaster.TABLENAME);
  //
  //   return List.generate(maps.length, (i) {
  //     return Broadcaster(
  //       id: maps[i]['Broadcaster_id'],
  //       email: maps[i]['Broadcaster_email'],
  //       password: maps[i]['content'],
  //     );
  //   });
  // }
}
