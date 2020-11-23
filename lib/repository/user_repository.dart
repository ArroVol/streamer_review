import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/model/user.dart';

class UserRepository {
  SharedPreferences prefs;
  // Database db = DatabaseHelper2.instance.database as Database;
  // UserRepository({this.prefs});

  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    Database db = await DatabaseHelper2.instance.database;

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
    Database db = await DatabaseHelper2.instance.database;
    // Map<String, dynamic > user = (await db.query('_user_table', where: '_id = ?', whereArgs: [id])) as Map<String, dynamic >;
    List<Map<String, dynamic>> user =
    await db.query('_user_table', where: '_id = ?', whereArgs: [id]);
    if (user.isEmpty) {
      print('The user with id: $id does not exist');
    } else {
      print('the user already exists');
    }
    return user;
  }
  //Query returns a list of map (must be passed as a type)
  //All data will be in the form of map, so it returns a list of map
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.query("_user_table");
  }

  Future<List<User>> getUserByUserName(String userName) async {
    Database db = await DatabaseHelper2.instance.database;
    List<Map<String, dynamic>> user = await db
        .query('_user_table', where: 'user_name = ?', whereArgs: [userName]);
    return List.generate(user.length, (i) {
      return User(
        id: user[i]['_id'],
        email: user[i]['email'],
        password: user[i]['password'],
        userName: user[i]['user_name'],
        phoneNumber: user[i]['phone_number'],
      );
    });
  }
  Future<int> getUserIdByUserName(String userName) async {
    Database db = await DatabaseHelper2.instance.database;
    List<Map<String, dynamic>> user = await db
        .query('_user_table', where: 'user_name = ?', whereArgs: [userName]);
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
    Database db = await DatabaseHelper2.instance.database;
    List<Map<String, dynamic>> user = await db
        .query('_user_table', where: 'user_name = ?', whereArgs: [email]);
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
    Database db = await DatabaseHelper2.instance.database;
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
    Database db = await DatabaseHelper2.instance.database;
    List<Map<String, dynamic>> userPulled =
    await db.query('_user_table', where: 'email = ?', whereArgs: [email]);
    if (userPulled.isNotEmpty) {
      print('The email matches one in the db');
      return true;
    }
    return false;
  }

  Future<bool> checkPasswordByPassword(String password) async {
    Database db = await DatabaseHelper2.instance.database;
    List<Map<String, dynamic>> userPulled = await db
        .query('_user_table', where: 'password = ?', whereArgs: [password]);
    if (userPulled.isNotEmpty) {
      print('The password matches one in the db');
      return true;
    }
    return false;
  }

  Future<bool> checkByUserName(String userName) async {
    Database db = await DatabaseHelper2.instance.database;
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
    Database db = await DatabaseHelper2.instance.database;
    return await db
        .delete('_user_table', where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<User>> retrieveUsers() async {
    Database db = await DatabaseHelper2.instance.database;

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
    Database db = await DatabaseHelper2.instance.database;
    List<User> newUser = await getUserByUserName(user.userName);
    int id = newUser.first.id;
    int updatedCount = await db.rawUpdate('''
    UPDATE _user_table 
    SET email = ?, password = ?, user_name = ?, phone_number = ? 
    WHERE _id = ?
    ''', [user.email, user.password, user.userName, user.phoneNumber, id]);
    return updatedCount;
  }



  static const String _IS_LOGGED_IN = "is_logged_in";
  static const String _NAME = "name";

  login(String name) async {
    await prefs.setBool(_IS_LOGGED_IN, true);
    await prefs.setString(_NAME, name);
  }

  Future<bool> isLoggedIn() async {
    // return prefs.containsKey(_IS_LOGGED_IN);
    return true;
    // prefs.k
  }

  Future<String> getName() async {
    return prefs.getString(_NAME);
  }

  logout() async {
    prefs.clear();
  }

  static final _dbName = 'sr.db';
  static final _dbVersion = 1;
  static final _tableName = '_user_table';

  //Fields given to the table
  static final columnId = '_id';
  static final columnEmail = 'email';
  static final columnPassword = 'password';
  // Database db = await DatabaseHelper2.instance.database;
// int is used to make all id values unique since they are auto incremented by 1
  Future<int> insertUserAsMap(Map<String, dynamic> row) async {
    //we need to get the database first
    Database db = await DatabaseHelper2.instance.database;
    //returns the primary key (unique id)
    return await db.insert(_tableName, row);
  }

//Query returns a list of map (must be passed as a type)
//All data will be in the form of map, so it returns a list of map
  Future<List<Map<String, dynamic>>> queryAllUsersOld() async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.query(_tableName);
  }

//to update you need to pass the id of which will be updated as well as pass the value
// takes in a map type parameter
  Future<int> updateUserOld(Map<String, dynamic> row) async {
   Database db = await DatabaseHelper2.instance.database;
    int id = row[columnId];

    //This will update the specific row
    //first question mark will be replaced by 1, second question mark will be replaced by saheb
    return await db.update(_tableName, row,
        where: '$columnId = ? $columnEmail = ?', whereArgs: [id]);
    //await because this will take some time
  }

//delete the record that has that id
  Future<int> deleteUserOld(int id) async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.delete(_tableName,
        where: '$columnId = ? $columnEmail = ?', whereArgs: [id]);
  }
}
