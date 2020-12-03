import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/model/broadcaster_tag.dart';
import 'package:streamer_review/model/user.dart';
import 'package:streamer_review/repository/broadcaster_repository.dart';

import 'package:streamer_review/streamer.dart';
import 'package:streamer_review/streamer_thumb.dart';
import 'dart:convert';
import 'package:streamer_review/secure_storage/secure_storage.dart';

// library for input and output
import 'dart:io';
import 'DatabaseCreator.dart';
///
///
class DatabaseHelper2 {
  //These are not given a type because it will automatically take the type that it is given first to it
  // Database name and database version are specified.
  static final _dbName = 'myDatabase24.db';
  static final _dbVersion = 1;
  static final _tableName = '_user_table';
  static final _reviewTable = 'reviews';

  // The secure storage that holds the user logged in.
  final SecureStorage secureStorage = SecureStorage();

  BroadcasterRepository broadcasterRepository = new BroadcasterRepository();

  //Fields given to the user table
  static final columnId = '_id';
  static final columnEmail = 'email';
  static final columnPassword = 'password';
  static final columnUserName = 'user_name';
  static final columnPhoneNumber = 'phone_number';
  static String directoryPath = '';

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
    directoryPath = path;
    // to open the database in SQlite
    // await is used since these functions take time to execute
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    //we need to give versions, to keep track of which version is being used as complexity increases in the application
  }

  //returns 2 parameters (database, version)
  // create the database if it doesnt exist
  Future _onCreate(Database db, int version) {

    secureStorage.deleteSecureData('email');
    secureStorage.deleteSecureData('password');
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

    db.execute('''
      CREATE TABLE text_reviews(
      favorites_id INTEGER PRIMARY KEY AUTOINCREMENT, 
      review_content TEXT,
      submission_date TEXT,
      fk_broadcaster_id INTEGER,
      fk_user_id INTEGER,
       FOREIGN KEY (fk_broadcaster_id)
        REFERENCES broadcaster_table(broadcaster_id),
       FOREIGN KEY (fk_user_id)
         REFERENCES _user_table(_id)  
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
    // addDummyData();
  }


  // Future<void> deleteDb() async {
  //   final Database db = await _holder.db;
  //   // delete database
  // }
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final Database db = await instance.database;

    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same user is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      '_user_table',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> retrieveUserById(int id) async {
    // Get a reference to the database.
    Database db = await instance.database;
    // Map<String, dynamic > user = (await db.query('_user_table', where: '_id = ?', whereArgs: [id])) as Map<String, dynamic >;
    List<Map<String, dynamic>> user =
        await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
    if (user.isEmpty) {
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

  //Query returns a list of map (must be passed as a type)
  //All data will be in the form of map, so it returns a list of map
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.database;
    return await db.query("_user_table");
  }

  Future<List<User>> getUserByUserName(String userName) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> user = await db
        .query('_user_table', where: 'user_name = ?', whereArgs: [userName]);
    final userMap = user.asMap();

    final user1 = userMap[0];

    for (var i = 0; i < 1; i++) {
      user[i];
    }

    // for (String key in user.keys){
    //   print(key);
    //   print(testMap[key]);
    // }
    return List.generate(user.length, (i) {
      return User(
        id: user[i]['_id'],
        email: user[i]['email'],
        password: user[i]['password'],
        userName: user[i]['user_name'],
        phoneNumber: user[i]['phone_number'],
      );
    });
    // return User(
    //   id: maps[i]['user_id'],
    //   email: maps[i]['user_email'],
    //   password: maps[i]['content'],
    // );
  }

  Future<int> getUserIdByUserName(String userName) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> user = await db
        .query('_user_table', where: 'user_name = ?', whereArgs: [userName]);
    final userMap = user.asMap();
    final user1 = userMap[0];

    List<User> userList = [];
    List.generate(user.length, (i) {
      userList.add(User(
        id: user[i]['_id'],
        // email: user[i]['email'],
        // password: user[i]['password'],
        // userName: user[i]['user_name'],
        // phoneNumber: user[i]['phone_number'],
      ));
    });
    int id = userList.first.id;
    return id;
  }
  Future<int> getUserIdByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> user = await db
        .query('_user_table', where: 'email = ?', whereArgs: [email]);
    final userMap = user.asMap();
    final user1 = userMap[0];

    List<User> userList = [];
    List.generate(user.length, (i) {
      userList.add(User(
        id: user[i]['_id'],
      ));
    });
    int id = userList.first.id;
    return id;
  }

  Future<void> checkUserIntoDatabase(User user) async {
    // Future<void> checkUserIntoDatabase(Map<String, dynamic> user) async {
    bool userExists = false;
    Database db = await instance.database;
    String userName = user.userName;

    List<Map<String, dynamic>> userPulled = await db.query('_user_table',
        where: 'user_name = ?', whereArgs: [user.userName]);
    if (userPulled.isNotEmpty) {
      print("The user name already exits in the DB");
    } else {
      checkEmail(db, user);
    }
    // await db.execute("SELECT COUNT(*) FROM _user_table WHERE user_name = :user_name", user.userName=user.userName);
  }

  Future<void> checkEmail(Database db, User user) async {
    List<Map<String, dynamic>> userPulled = await db
        .query('_user_table', where: 'email = ?', whereArgs: [user.email]);
    if (userPulled.isNotEmpty) {
      print("The email already exits in the DB");
    } else {
      checkPhoneNumber(db, user);
    }
  }

  Future<bool> checkEmailByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> userPulled =
        await db.query('_user_table', where: 'email = ?', whereArgs: [email]);
    if (userPulled.isNotEmpty) {
      print('The email matches one in the db');
      return true;
    }
    return false;
  }

  Future<bool> checkPasswordByPassword(String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> userPulled = await db
        .query('_user_table', where: 'password = ?', whereArgs: [password]);
    if (userPulled.isNotEmpty) {
      print('The password matches one in the db');
      return true;
    }
    return false;
  }

  Future<bool> checkByUserName(String userName) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> userPulled = await db
        .query('_user_table', where: 'email = ?', whereArgs: [userName]);
    if (userPulled.isNotEmpty) {
      print('The user name: $userName matches one in the db');
      return true;
    }
    print('The user name: $userName DOES NOT match one in the db');
    return false;
  }

  Future<void> checkPhoneNumber(Database db, User user) async {
    List<Map<String, dynamic>> userPulled = await db.query('_user_table',
        where: 'phone_number = ?', whereArgs: [user.phoneNumber]);
    if (userPulled.isNotEmpty) {
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

  //delete the record that has that id
  Future<int> deleteUser(int id) async {
    print('deleting...');
    print(id);
    Database db = await instance.database;
    return await db
        .delete('_user_table', where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<User>> retrieveUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(User.TABLENAME);

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['_id'],
        email: maps[i]['email'],
        password: maps[i]['password'],
        userName: maps[i]['user_name'],
        phoneNumber: maps[i]['phone_number'],
      );
    });
  }

  //to update you need to pass the id of which will be updated as well as pass the value
  // takes in a map type parameter
  Future<int> updateUser(User user) async {
    print("in the update method for user in the database");
    print(user.toMap());
    Database db = await instance.database;
    String userName = user.userName;
    List<User> newUser = await getUserByUserName(user.userName);
    int id = newUser.first.id;
    // List<Map<String, dynamic >> user = await db.query('_user_table', where: '_id = ?', whereArgs: []);

    int updatedCount = await db.rawUpdate('''
    UPDATE _user_table 
    SET email = ?, password = ?, user_name = ?, phone_number = ? 
    WHERE _id = ?
    ''', [user.email, user.password, user.userName, user.phoneNumber, id]);
    return updatedCount;
  }

  Future<void> addBroadcasterTag(BroadcasterTag broadcasterTag) async {
    return await db.insert(
      'broadcaster_tags',
      broadcasterTag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> insertBroadcasterTag(
      broadcasterId, tagName) async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;

    // raw query
    List<Map> result = await db.rawQuery(
        'SELECT * FROM broadcaster_tags WHERE fk_broadcaster_id=?',
        [broadcasterId]);
    await db.rawQuery(
        'INSERT INTO broadcaster_tags (tag_name, fk_broadcaster_id) VALUES(?, ?)',
        [tagName, broadcasterId]);
    // await db.rawQuery('UPDATE reviews SET satisfaction_rating = ?, entertainment_rating = ?, interactiveness_rating = ?, skill_rating = ? WHERE fk_broadcaster_id = ? AND fk_user_id = ?', [satisfaction_rating, entertainment_rating, interactiveness_rating, skill_rating, broadcaster_id, user_id]);


    return result;
  }

  Future<List<Map<String, dynamic>>> selectAllBroadcasterTagsByBroadcaster(
      broadcasterId) async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;
    // raw query
    List<Map> result = await db.rawQuery(
        'SELECT * FROM broadcaster_tags WHERE fk_broadcaster_id=?',
        [broadcasterId]);
    return result;
  }

  Future<List<Map<String, dynamic>>> selectAllBroadcastersByBroadcasterTag(
      tagName) async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;

    // raw query
    List<Map> result = await db
        .rawQuery('SELECT * FROM broadcaster_tags WHERE tag_name=?', [tagName]);
    // await db.rawQuery('UPDATE reviews SET satisfaction_rating = ?, entertainment_rating = ?, interactiveness_rating = ?, skill_rating = ? WHERE fk_broadcaster_id = ? AND fk_user_id = ?', [satisfaction_rating, entertainment_rating, interactiveness_rating, skill_rating, broadcaster_id, user_id]);
    return result;
  }

  Future<void> tesAss() async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;

    // get all rows
    List<Map> result = await db.query(DatabaseHelper2._tableName);

    // print the results
    result.forEach((row) => print(row));
    // {_id: 1, name: Bob, age: 23}
    // {_id: 2, name: Mary, age: 32}
    // {_id: 3, name: Susan, age: 12}
  }

  Future<List<Map<String, dynamic>>> selectTextReviews(
      broadcaster_id) async {
    Database db = await DatabaseHelper2.instance.database;

    // raw query
    List<Map> result = await db.rawQuery(
        'SELECT * FROM text_reviews WHERE fk_broadcaster_id=? ORDER BY datetime(submission_date) DESC',
        [broadcaster_id]);

    return result;
  }

  Future<void> insertTextReviews(
      review_content, submission_date, broadcaster_id, user_id) async {
    // get a reference to the database
    int count = 0;
    Database db = await DatabaseHelper2.instance.database;

    await db.rawQuery(
        'INSERT INTO text_reviews (review_content, submission_date, fk_broadcaster_id, fk_user_id) VALUES(?, ?, ?, ?)',
        [
          review_content,
          submission_date,
          broadcaster_id,
          user_id
        ]);
  }

  Future<List<Map<String, dynamic>>> selectReviews(
      broadcaster_id, user_id) async {
    // get a reference to the database
    int count = 0;
    Database db = await DatabaseHelper2.instance.database;

    // raw query
    List<Map> result = await db.rawQuery(
        'SELECT * FROM reviews WHERE fk_user_id=? AND fk_broadcaster_id=?',
        [user_id, broadcaster_id]);

    // print the results
    // result.forEach((row) => print(row));
    // {_id: 2, name: Mary, age: 32}
    return result;
  }

  Future<List<Map<String, dynamic>>> selectBroadcaster(broadcaster_id) async {
    // get a reference to the database

    Database db = await DatabaseHelper2.instance.database;

    // raw query
    List<Map> result = await db.rawQuery(
        'SELECT * FROM broadcaster_table WHERE broadcaster_id=?',
        [broadcaster_id]);
    // List<Map> result2 = await db.rawQuery('SELECT * FROM broadcaster_table WHERE broadcaster_id=?', [broadcaster_id]);
    // List<Map> result = await db.rawQuery('SELECT * FROM broadcaster_table WHERE user_id=?', [1]);
    // print('WE ARE HERE');
    // print(broadcaster_id);
    // print(result2);

    return result;
  }

  Future<List<Map>> selectAllBroadcasters() async {
    Database db = await DatabaseHelper2.instance.database;
    List<Map> result = await db.rawQuery('SELECT * FROM broadcaster_table');
    print(result[0]);
    // List<StreamerThumb> streamerThumbList;
    // for(var i = 0; i < result.length; i++){
    //   if(result[i]['broadcaster_name'] != null){
    //     streamerThumbList.add(new StreamerThumb(result[i]['broadcaster_name']));
    //   }
    // }
    return result;
  }


  Future<int> insertReview(satisfaction_rating, entertainment_rating,
      interactiveness_rating, skill_rating, broadcaster_id, user_id, login) async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;
    int count;
    List<Map> result = await db.rawQuery(
      'SELECT * FROM reviews WHERE fk_user_id=? AND fk_broadcaster_id=?',
      [user_id, broadcaster_id],
    );
    count = result.length;
    print(result);
    print('COUNT ' + count.toString());

    // raw query
    if (count == 0) {
      await db.rawQuery(
          'INSERT INTO reviews (satisfaction_rating, entertainment_rating, interactiveness_rating, skill_rating, fk_broadcaster_id, fk_user_id) VALUES(?, ?, ?, ?, ?, ?)',
          [
            satisfaction_rating,
            entertainment_rating,
            interactiveness_rating,
            skill_rating,
            broadcaster_id,
            user_id
          ]);
    } else {
      await db.rawQuery(
          'UPDATE reviews SET satisfaction_rating = ?, entertainment_rating = ?, interactiveness_rating = ?, skill_rating = ? WHERE fk_broadcaster_id = ? AND fk_user_id = ?',
          [
            satisfaction_rating,
            entertainment_rating,
            interactiveness_rating,
            skill_rating,
            broadcaster_id,
            user_id
          ]);
    }
    double temp_satisfaction_rating = 0;
    double temp_entertainment_rating = 0;
    double temp_interaction_rating = 0;
    double temp_skill_rating = 0;
    for (var i = 0; i < result.length; i++) {
      // print('HERE');
      temp_satisfaction_rating += result[i]['satisfaction_rating'];
      temp_entertainment_rating += result[i]['entertainment_rating'];
      temp_interaction_rating += result[i]['interactiveness_rating'];
      temp_skill_rating += result[i]['skill_rating'];
    }
    // print('HERE 2');
    temp_satisfaction_rating /= result.length;
    temp_entertainment_rating /= result.length;
    temp_interaction_rating /= result.length;
    temp_skill_rating /= result.length;
    // print(temp_satisfaction_rating);
    // print(temp_entertainment_rating);
    // print(temp_interaction_rating);
    // print(temp_skill_rating);
    await insertBroadcaster(temp_satisfaction_rating, temp_skill_rating,
        temp_entertainment_rating, temp_interaction_rating, broadcaster_id, login);
    // db = await DatabaseHelper2.instance.database;
    // List<Map> result2 = await db.rawQuery('SELECT * FROM broadcaster_table WHERE broadcaster_id=?', [broadcaster_id],);
    // count = result2.length;
    // if(count == 0) {
    //   db.rawQuery('INSERT INTO broadcaster_table (broadcaster_id, broadcaster_name, overall_satisfaction, overall_entertainment, overall_interactiveness, overall_skill) VALUES(?, ?, ?, ?, ?, ?)', [broadcaster_id, 'test', temp_satisfaction_rating, temp_skill_rating, temp_entertainment_rating, temp_interaction_rating]);
    // } else {
    //   db.rawQuery('UPDATE broadcaster_table SET overall_satisfaction = ?, overall_skill = ?, overall_entertainment = ?, overall_interactiveness = ? WHERE broadcaster_id = ?', [temp_satisfaction_rating, temp_skill_rating, temp_entertainment_rating, temp_interaction_rating, broadcaster_id]);
    // }

    // List<Map> result = await db.rawQuery('SELECT * FROM reviews WHERE fk_user_id=? AND fk_broadcaster_id=?', [user_id, broadcaster_id],);

    // print the results
    // result.forEach((row) => print(row));
    // {_id: 2, name: Mary, age: 32}
    return 0;
  }


  Future<void> updateBroadcaster(broadcaster_id, user_id, login) async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;
    List<Map> result = await db.rawQuery(
      'SELECT * FROM reviews WHERE fk_user_id=? AND fk_broadcaster_id=?',
      [user_id, broadcaster_id],
    );
    double temp_satisfaction_rating = 0;
    double temp_entertainment_rating = 0;
    double temp_interaction_rating = 0;
    double temp_skill_rating = 0;
    for (var i = 0; i < result.length; i++) {
      temp_satisfaction_rating += result[i]['satisfaction_rating'];
      temp_entertainment_rating += result[i]['entertainment_rating'];
      temp_interaction_rating += result[i]['interactiveness_rating'];
      temp_skill_rating += result[i]['skill_rating'];
    }
    temp_satisfaction_rating /= result.length;
    temp_entertainment_rating /= result.length;
    temp_interaction_rating /= result.length;
    temp_skill_rating /= result.length;
    await insertBroadcaster(temp_satisfaction_rating, temp_skill_rating,
        temp_entertainment_rating, temp_interaction_rating, broadcaster_id, login);
    return 0;
  }

  Future<int> insertBroadcaster(
      temp_satisfaction_rating,
      temp_skill_rating,
      temp_entertainment_rating,
      temp_interaction_rating,
      broadcaster_id, login) async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;
    int count;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM broadcaster_table WHERE broadcaster_id=?',
        [broadcaster_id]);
    count = result.length;
    if (count == 0) {
      db.rawQuery(
          'INSERT INTO broadcaster_table (broadcaster_id, broadcaster_name, overall_satisfaction, overall_entertainment, overall_interactiveness, overall_skill) VALUES(?, ?, ?, ?, ?, ?)',
          [
            broadcaster_id,
            login,
            temp_satisfaction_rating,
            temp_skill_rating,
            temp_entertainment_rating,
            temp_interaction_rating
          ]);
    } else {
      db.rawQuery(
          'UPDATE broadcaster_table SET overall_satisfaction = ?, overall_skill = ?, overall_entertainment = ?, overall_interactiveness = ? WHERE broadcaster_id = ?',
          [
            temp_satisfaction_rating,
            temp_skill_rating,
            temp_entertainment_rating,
            temp_interaction_rating,
            broadcaster_id
          ]);
    }
    return 0;
  }

  Future<void> clearReviews() async {
    Database db = await DatabaseHelper2.instance.database;
    db.rawQuery('DELETE FROM reviews WHERE reviews_id >= 0');
  }

  // Future addDummyData(){
  //   // db.execute(''' INSERT INTO _user_table (EMAIL, PASSWORD, PHONE_NUMBER, USERNAME)
  //   // VALUES('Gooby@gmail.com', 'gooby4ever', '708-843-6969', 'GoobyChan')
  //   // '''
  //   // );
  // }
  Future<void> insertFavorite(int broadcasterId) async {
    Database db = await DatabaseHelper2.instance.database;
    String userEmail = await secureStorage.readSecureData("email");
    int userId = await DatabaseHelper2.instance.getUserIdByEmail(userEmail);
    print("**inserting favorite: $userId**");

    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same user is inserted twice.
    // In this case, replace any previous data.
    await db.rawQuery(
        'INSERT INTO user_favorites (fk_broadcaster_id, fk_user_id) VALUES(?, ?)',
        [broadcasterId, userId]);
  }
  Future<int> deleteFavorite(int broadcasterId) async {
    print("in the delete method for favorite in the database");
    Database db = await DatabaseHelper2.instance.database;
    String userEmail = await secureStorage.readSecureData("email");
    int userId = await DatabaseHelper2.instance.getUserIdByEmail(userEmail);

    int deletedRow = await db.delete('user_favorites', where: 'fk_broadcaster_id = ?', whereArgs: [broadcasterId]);
    return deletedRow;
  }

  // int is used to make all id values unique since they are auto incremented by 1
  Future<int> insert(Map<String, dynamic> row) async {
    //we need to get the database first
    // calls the get database method above
    print("row:  $row");
    Database db = await instance.database;
    //returns the primary key (unique id)
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

  Future resetBroadcasters() async {
    Database db = await instance.database;
    db.execute("DELETE FROM broadcaster_table");
    db.execute("DROP TABLE broadcaster_table");
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

// List<Map<String, dynamic >> mPeople = user.map((m) => Map.of(m)).toList();
// user.indexOf();
// User pulledUser = User.fromMap(user.indexOf(0));

// Future<List<Map<String, dynamic>>> addUserToDatabase(User user) async {
//   // Get a reference to the database.
//   Database db = await instance.database;
//   //check if the user already exists
//   List<Map<String, dynamic >> user = await
//   db.query('_user_table', where: '_id = ?', whereArgs: []);
//   if(user.isEmpty){
//     // print('The user with id: $id does not exist');
//   } else {
//     print('the user already exists');
//   }
//   return user;
//
//   }
// return await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
//
// List<Map<String, dynamic >> user = await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
// return user.isNotEmpty ? User.fromMap(user.first): Null;
