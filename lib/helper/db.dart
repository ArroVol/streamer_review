import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/model/user.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';

class DBProvider {
  // final SecureStorage secureStorage = SecureStorage();

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    // secureStorage.deleteSecureData('email');
    // secureStorage.deleteSecureData('password');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'streamer_review.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          //write the query that creates the database
          //3 single quotes allows us to write the lines as a single string (command)

         await db.execute('''
      CREATE TABLE _user_table(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      phone_number TEXT,
      user_name TEXT NOT NULL)
      ''');
          db.execute('''
      CREATE TABLE broadcaster_table(
      broadcaster_id INTEGER PRIMARY KEY,
      broadcaster_name TEXT NOT NULL,
      overall_satisfaction REAL, 
      overall_skill REAL, 
      overall_entertainment REAL, 
      overall_interactiveness REAL 
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
      CREATE TABLE broadcaster_tags(
      tags_id INTEGER PRIMARY KEY AUTOINCREMENT,
      tag_name TEXT,
      fk_broadcaster_id INTEGER,
      FOREIGN KEY (fk_broadcaster_id)
        REFERENCES broadcaster_table(broadcaster_id)
      )
      ''');

          // db.execute(
          //     ''' INSERT INTO _user_table (email, password, phone_number, user_name)
          // VALUES('gooby@gmail.com', 'gooby4ever', '708-843-6969', 'goobychan')
          // ''');
          db.execute(
              ''' INSERT INTO broadcaster_table (broadcaster_id, broadcaster_name)
    VALUES(229729353, 'criticalrole')
    ''');
        });
  }

  /// This method inserts a user object directly into the database.
  ///
  /// [user], the user object containing user data.
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await database;
    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same user is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      '_user_table',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
