import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:meta/meta.dart';



class userRepository2 {

  static final _dbName = 'sr.db';
  static final _dbVersion = 1;
  static final _tableName = '_user_table';

  //Fields given to the table
  static final columnId = '_id';
  static final columnEmail = 'email';
  static final columnPassword = 'password';
  DatabaseHelper2 db = DatabaseHelper2.instance;
// int is used to make all id values unique since they are auto incremented by 1
  Future<int> insertUser(Map<String, dynamic> row) async {
    //we need to get the database first
    Database db = await DatabaseHelper2.instance.database;
    //returns the primary key (unique id)
    return await db.insert(_tableName, row);
  }

//Query returns a list of map (must be passed as a type)
//All data will be in the form of map, so it returns a list of map
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.query(_tableName);
  }

//to update you need to pass the id of which will be updated as well as pass the value
// takes in a map type parameter
  Future<int> updateUser(Map<String, dynamic> row) async {
    Database db = await DatabaseHelper2.instance.database;
    int id = row[columnId];

    //This will update the specific row
    //first question mark will be replaced by 1, second question mark will be replaced by saheb
    return await db.update(_tableName, row,
        where: '$columnId = ? $columnEmail = ?', whereArgs: [id]);
    //await because this will take some time
  }

//delete the record that has that id
  Future<int> deleteUser(int id) async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.delete(_tableName,
        where: '$columnId = ? $columnEmail = ?', whereArgs: [id]);
  }
}
