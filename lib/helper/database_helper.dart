import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:streamer_review/model/user.dart';
import 'dart:convert';

// library for input and output
import 'dart:io';

import 'DatabaseCreator.dart';

class DatabaseHelper2 {
  //These are not given a type because it will automatically take the type that it is given first to it
  //we need to have a database name and database version
  static final _dbName = 'myDatabase21.db';
  static final _dbVersion = 1;
  static final _tableName = '_user_table';

  //Fields given to the table
  static final columnId = '_id';
  static final columnEmail = 'email';
  static final columnPassword = 'password';
  static final columnUserName = 'user_name';
  static final columnPhoneNumber = 'phone_number';




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
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnEmail TEXT NOT NULL,
      $columnPassword TEXT NOT NULL,
      phone_number TEXT,
      user_name TEXT NOT NULL)
      ''');
    db.execute('''
      CREATE TABLE broadcaster_table(
      broadcaster_id INTEGER PRIMARY KEY,
      broadcaster_name TEXT NOT NULL,
      overall_satisfaction INTEGER, 
      overall_skill INTEGER, 
      overall_entertainment INTEGER, 
      overall_interactiveness INTEGER 
      )
      ''');
    db.execute('''
      CREATE TABLE user_favorites(
      favorites_id INTEGER PRIMARY KEY AUTOINCREMENT, 
      fk_broadcaster_id INTEGER,
      fk_user_id INTEGER,
       FOREIGN KEY (fk_broadcaster_id)
        REFERENCES broadcaster_table(broadcaster_id),
       FOREIGN KEY (fk_user_id)
         REFERENCES _user_table(_id)  
        )
      ''');
    db.execute('''
      CREATE TABLE reviews(
      reviews_id INTEGER PRIMARY KEY AUTOINCREMENT,
      satisfaction_rating INTEGER, 
      entertainment_rating INTEGER, 
      interactiveness_rating INTEGER, 
      skill_rating INTEGER, 
      fk_broadcaster_id INTEGER,
      fk_user_id INTEGER,
       FOREIGN KEY (fk_broadcaster_id)
        REFERENCES broadcaster_table(broadcaster_id),
       FOREIGN KEY (fk_user_id)
         REFERENCES _user_table(_id)  
        )
      ''');
    db.execute('''
      CREATE TABLE broadcaster_Tags(
      tags_id INTEGER PRIMARY KEY AUTOINCREMENT,
      tag_name TEXT,
      fk_broadcaster_id INTEGER,
      FOREIGN KEY (fk_broadcaster_id)
        REFERENCES broadcaster_table(broadcaster_id)
      )
      ''');
    db.execute(''' INSERT INTO _user_table (email, password, phone_number, user_name)
    VALUES('Gooby@gmail.com', 'gooby4ever', '708-843-6969', 'GoobyChan')
    '''
    );
    db.execute(''' INSERT INTO broadcaster_table (broadcaster_id, broadcaster_name)
    VALUES(229729353, 'criticalrole')
    '''
    );
    // addDummyData();
  }

  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final Database db = await instance.database;

    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
   return await db.insert(
      '_user_table',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> retrieveUser(int id) async {
    // Get a reference to the database.
    Database db = await instance.database;
    // Map<String, dynamic > user = (await db.query('_user_table', where: '_id = ?', whereArgs: [id])) as Map<String, dynamic >;
    List<Map<String, dynamic >> user = await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
    if(user.isEmpty){
      print('The user with id: $id does not exist');
    } else {
      print('the user already exists');
    }
    return user;
    // return await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
    //
    // List<Map<String, dynamic >> user = await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
    // return user.isNotEmpty ? User.fromMap(user.first): Null;

  }

  Future<List<Map<String, dynamic>>> addUserToDatabase(User user) async {
    // Get a reference to the database.
    Database db = await instance.database;
    //check if the user already exists
    List<Map<String, dynamic >> user = await
    db.query('_user_table', where: '_id = ?', whereArgs: []);
    if(user.isEmpty){
      // print('The user with id: $id does not exist');
    } else {
      print('the user already exists');
    }
    return user;

    }
    // return await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
    //
    // List<Map<String, dynamic >> user = await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
    // return user.isNotEmpty ? User.fromMap(user.first): Null;

  Future<void> checkUserIntoDatabase(User user) async {

    // Future<void> checkUserIntoDatabase(Map<String, dynamic> user) async {
    bool userExists = false;
    Database db = await instance.database;
    String userName = user.userName;

    List<Map<String, dynamic >> userPulled = await db.query('_user_table', where: 'user_name = ?', whereArgs: [user.userName]);
    if(userPulled.isNotEmpty){
      print("The user name already exits in the DB");

    } else {
     checkEmail(db, user);

    }
    // await db.execute("SELECT COUNT(*) FROM _user_table WHERE user_name = :user_name", user.userName=user.userName);
}

Future<void> checkEmail(Database db, User user) async{
  List<Map<String, dynamic >> userPulled = await db.query('_user_table', where: 'email = ?', whereArgs: [user.email]);
  if(userPulled.isNotEmpty){
    print("The email already exits in the DB");
  } else {
    checkPhoneNumber(db, user);
  }
}

  Future<bool> checkEmailByEmail(String email) async{
    Database db = await instance.database;
    List<Map<String, dynamic >> userPulled = await db.query('_user_table', where: 'email = ?', whereArgs: [email]);
    if(userPulled.isNotEmpty){
      print('The email matches one in the db');
      return true;
    }
    return false;

  }

  Future<bool> checkPasswordByPassword(String password) async{
    Database db = await instance.database;
    List<Map<String, dynamic >> userPulled = await db.query('_user_table', where: 'password = ?', whereArgs: [password]);
    if(userPulled.isNotEmpty){
      print('The password matches one in the db');
      return true;
    }
    return false;

  }

  Future<bool> checkByUserName(String userName) async{
    Database db = await instance.database;
    List<Map<String, dynamic >> userPulled = await db.query('_user_table', where: 'email = ?', whereArgs: [userName]);
    if(userPulled.isNotEmpty){
      print('The user name: $userName matches one in the db');
      return true;
    }
    print('The user name: $userName DOES NOT match one in the db');
    return false;

  }

  Future<void> checkPhoneNumber(Database db, User user) async {
    List<Map<String, dynamic >> userPulled = await db.query('_user_table', where: 'phone_number = ?', whereArgs: [user.phoneNumber]);
    if(userPulled.isNotEmpty) {
      print("The phone number already exits in the DB");
    } else {
      addVerifiedUserToDatabase(db, user);
    }
  }

  Future<void> addVerifiedUserToDatabase(Database db, User user) async {
    return await db.insert(
      '_user_table',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



    // Future addDummyData(){
  //   // db.execute(''' INSERT INTO _user_table (EMAIL, PASSWORD, PHONE_NUMBER, USERNAME)
  //   // VALUES('Gooby@gmail.com', 'gooby4ever', '708-843-6969', 'GoobyChan')
  //   // '''
  //   // );
  // }

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
    return await db.query("_user_table");

    // return await db.query(_tableName);
  }
  //Query returns a list of map (must be passed as a type)
  //All data will be in the form of map, so it returns a list of map
  Future<List<Map<String, dynamic>>> queryAllStreamers() async {
    Database db = await instance.database;
    return await db.query("broadcaster_table");

    // return await db.query(_tableName);
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
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
    //await because this will take some time
  }

  //delete the record that has that id
  Future<int> delete(int id) async {
    print('deleting...');
    print(id);
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
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
    // db.execute("DROP TABLE IF EXISTS _user_table");
    db.execute("DELETE FROM _user_table");
    db.execute("DROP TABLE _user_table");
    db.execute('''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnEmail TEXT NOT NULL,
      $columnPassword TEXT NOT NULL)
      ''');
  }

  //returns 2 parameters (database, version)
  // create the database if it doesnt exist
  Future createUserTable() {
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
//
// db.execute('''
//       CREATE TABLE $_tableName(
//       $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
//       $columnEmail TEXT NOT NULL,
//       $columnPassword TEXT NOT NULL)
//
//       ''');
// db.execute('''
//       CREATE TABLE broadcaster_table(
//       broadcaster_id INTEGER PRIMARY KEY,
//       broadcaster_name TEXT NOT NULL,
//       overall_satisfaction INTEGER,
//       overall_skill INTEGER,
//       overall_entertainment INTEGER,
//       overall_interactiveness INTEGER,
//       )
//       ''');
// db.execute('''
//       CREATE TABLE user_favorites(
//       favorites_id INTEGER PRIMARY KEY AUTO INCREMENT,
//       CONSTRAINT fk_user_table
//         FOREIGN KEY (_id)
//         REFERENCES _user_table(_id)
//       )
//       CONSTRAINT fk_broadcaster_table
//         FOREIGN KEY (broadcaster_id)
//         REFERENCES broadcaster_table(broadcaster_id)
//       )
//       ''');
// db.execute('''
//       CREATE TABLE reviews(
//       reviews_id INTEGER PRIMARY KEY,
//       satisfaction_rating INTEGER,
//       entertainment_rating INTEGER,
//       interactiveness_rating INTEGER,
//       skill_rating INTEGER,
//       CONSTRAINT fk_user_table
//         FOREIGN KEY (_id)
//         REFERENCES _user_table(_id)
//       CONSTRAINT fk_broadcaster_table
//         FOREIGN KEY (broadcaster_id)
//         REFERENCES broadcaster_table(broadcaster_id)
//       )
//       ''');
// db.execute('''
//       CREATE TABLE broadcaster_Tags(
//       tags_id INTEGER PRIMARY KEY AUTO INCREMENT,
//       tag_name TEXT,
//       CONSTRAINT fk_broadcaster_table
//         FOREIGN KEY (broadcaster_id)
//         REFERENCES broadcaster_table(broadcaster_id)
//       )
//       ''');
// }
