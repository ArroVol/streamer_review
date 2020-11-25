import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';

class BroadcasterRepository  {

  static final _dbVersion = 1;
  static final _tableName = 'broadcaster_table';


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

  //Query returns a list of map (must be passed as a type)
  //All data will be in the form of map, so it returns a list of map
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.query(_tableName);
  }

  Future<void> updateBroadcaster(broadcaster_id, user_id) async {
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
        temp_entertainment_rating, temp_interaction_rating, broadcaster_id);
    return 0;
  }

  Future<int> insertBroadcaster(
      temp_satisfaction_rating,
      temp_skill_rating,
      temp_entertainment_rating,
      temp_interaction_rating,
      broadcaster_id) async {
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
            'test',
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

  // int is used to make all id values unique since they are auto incremented by 1
  Future<int> insert(Map<String, dynamic> row) async {
    //we need to get the database first
    // calls the get database method above
    Database db = await DatabaseHelper2.instance.database;

    return await db.insert(_tableName, row);
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
