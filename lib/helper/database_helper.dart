import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:streamer_review/model/User.dart';
import 'dart:convert';

// library for input and output
import 'dart:io';

import 'DatabaseCreator.dart';

class DatabaseHelper2 {
  //These are not given a type because it will automatically take the type that it is given first to it
  //we need to have a database name and database version
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tableName = '_user_table';

  //Fields given to the table
  static final columnId = '_id';
  static final columnEmail = 'email';
  static final columnPassword = 'password';


  //making it a singleton class
  DatabaseHelper2._privateConstructor();

  //static and constant, once it is initiated it will not be changed
  //create only one instance of this database class
  static final DatabaseHelper2 instance = DatabaseHelper2._privateConstructor();

  //initialize the database
  //only be accessed using this class name, values only accessed using this class name
  //initially the application will be null
  static Database _database;

  //This function will be returning the database
  Future<Database> get database async {
    if (_database != null) return _database;
    //create (initialize) our new database into a local directory
    _database = await _initiateDatabase();

    return _database;
  }

  _initiateDatabase() async {
    //default documents directory, just like in your local machine documents
    Directory directory = await getApplicationDocumentsDirectory();
    //join the file name and the path
    String path = join(directory.path, _dbName);
    // to open the database in SQlite
    // await is used since these functions take time to execute
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    //we need to give versions, to keep track of which version is being used as complexity increases in the application
  }

  //returns 2 parameters (database, version)
  // create the database if it doesnt exist
  Future _onCreate(Database db, int version) {
    //write the query that creates the database
    //3 single quotes allows us to write the lines as a single string (command)

    db.execute('''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnEmail TEXT NOT NULL,
      $columnPassword TEXT )
      ''');
  }

  // int is used to make all id values unique since they are auto incremented by 1
  Future<int> insert(Map<String, dynamic> row) async {
    //we need to get the database first
    // calls the get database method above
    print("row:  $row");
    Database db = await instance.database;
    //returns the primary key (unique id)

    // final textUser = User(
    //   id: 0,
    //   email: 'Gooby4Ever',
    //   password: 'YeetBois',
    // );
    //
    //
    // var res = await db.insert(_tableName, textUser.toJson(),
    //     conflictAlgorithm: ConflictAlgorithm.replace);
    return await db.insert(_tableName, row);
  }

  //Query returns a list of map (must be passed as a type)
  //All data will be in the form of map, so it returns a list of map
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  //to update you need to pass the id of which will be updated as well as pass the value
  // takes in a map type parameter
  Future<int> update(Map<String, dynamic> row) async {
    print("in the update method in the database");
    print(row);
    Database db = await instance.database;
    int id = row[columnId];

    //This will update the specific row
    //first question mark will be replaced by 1, second question mark will be replaced by saheb
    return await db.update(_tableName, row,
        where: '$columnId = ?',  whereArgs: [id]);
    //await because this will take some time
  }

  //delete the record that has that id
  Future<int> delete(int id) async {
    print('deleting...');
    print(id);
    Database db = await instance.database;
    return await db.delete(_tableName,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<User>> retrieveUsers() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(User.TABLENAME);

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['user_id'],
        email: maps[i]['user_email'],
        password: maps[i]['content'],
      );
    });
  }

  Future resetDb() async {
    Database db = await instance.database;
    db.execute("DROP TABLE IF EXISTS _user_table");


  }

  //returns 2 parameters (database, version)
  // create the database if it doesnt exist
  Future createUserTable () {
    //write the query that creates the database
    //3 single quotes allows us to write the lines as a single string (command)

    db.execute('''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnEmail TEXT NOT NULL,
      $columnPassword TEXT )
      ''');
  }
}




// class DatabaseHelper2 {
//   //These are not given a type because it will automatically take the type that it is given first to it
//   //we need to have a database name and database version
//   static final _dbName = 'myDatabase.db';
//   static final _dbVersion = 1;
//   static final _tableName = '_user_table';
//
//   //Fields given to the table
//   static final columnId = '_id';
//   static final columnName = 'name';
//
//   //making it a singleton class
//   DatabaseHelper2._privateConstructor();
//
//   //static and constant, once it is initiated it will not be changed
//   //create only one instance of this database class
//   static final DatabaseHelper2 instance = DatabaseHelper2._privateConstructor();
//
//   //initialize the database
//   //only be accessed using this class name, values only accessed using this class name
//   //initially the application will be null
//   static Database _database;
//
//   //This function will be returning the database
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     //create (initialize) our new database into a local directory
//     _database = await _initiateDatabase();
//
//     return _database;
//   }
//
//   _initiateDatabase() async {
//     //default documents directory, just like in your local machine documents
//     Directory directory = await getApplicationDocumentsDirectory();
//     //join the file name and the path
//     String path = join(directory.path, _dbName);
//     // to open the database in SQlite
//     // await is used since these functions take time to execute
//     return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
//     //we need to give versions, to keep track of which version is being used as complexity increases in the application
//   }
//
//   //returns 2 parameters (database, version)
//   // create the database if it doesnt exist
//   Future _onCreate(Database db, int version) {
//     //write the query that creates the database
//     //3 single quotes allows us to write the lines as a single string (command)
//     db.execute('''
//       CREATE TABLE $_tableName(
//       $columnId INTEGER PRIMARY KEY,
//       $columnName TEXT NOT NULL )
//       ''');
//   }
//
//   // int is used to make all id values unique since they are auto incremented by 1
//   Future<int> insert(Map<String, dynamic> row) async {
//     //we need to get the database first
//     // calls the get database method above
//     Database db = await instance.database;
//     //returns the primary key (unique id)
//     return await db.insert(_tableName, row);
//   }
//
//   //Query returns a list of map (must be passed as a type)
//   //All data will be in the form of map, so it returns a list of map
//   Future<List<Map<String, dynamic>>> queryAll() async {
//     Database db = await instance.database;
//     return await db.query(_tableName);
//   }
//
//   //to update you need to pass the id of which will be updated as well as pass the value
//   // takes in a map type parameter
//   Future<int> update(Map<String, dynamic> row) async {
//     print("in the update method in the database");
//     print(row);
//     Database db = await instance.database;
//     int id = row[columnId];
//
//     //This will update the specific row
//     //first question mark will be replaced by 1, second question mark will be replaced by saheb
//     return await db.update(_tableName, row,
//         where: '$columnId = ?',  whereArgs: [id]);
//     //await because this will take some time
//   }
//
//   //delete the record that has that id
//   Future<int> delete(int id) async {
//     Database db = await instance.database;
//     return await db.delete(_tableName,
//         where: '$columnId = ? $columnName = ?', whereArgs: [id]);
//   }
