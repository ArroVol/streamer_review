import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';

/// This class holds the basic CRUD operations for the user's review of a broadcaster.
class ReviewRepository {

  static final _tableName = 'reviews';

  /// This method selects all reviews for a broadcaster.
  ///
  /// [broadcaster_id], the broadcasters unique id from twitch.
  /// [user_id], the user's primary key id.
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
  /// This method inserts a review into the review table.
  ///
  /// [satisfaction_rating], the satisfaction rating given by the user to the broadcaster.
  /// [entertainment_rating], the entertainment rating given by the user to the broadcaster.
  /// [interactivness_rating], the interactiveness rating given by the user to the broadcaster.
  /// [skill_rating], the satisfaction rating given by the user to the broadcaster.
  /// [broadcaster_id], the broadcaster's id from twitch.
  /// [user_id], the user's id.
  Future<int> insertReview(satisfaction_rating, entertainment_rating,
      interactiveness_rating, skill_rating, broadcaster_id, user_id) async {
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
      // if the broadcaster has not been reviewed yet.
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
        temp_entertainment_rating, temp_interaction_rating, broadcaster_id);
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

  /// Clears all reviews from the database.
  Future<void> clearReviews() async {
    Database db = await DatabaseHelper2.instance.database;
    db.rawQuery('DELETE FROM reviews WHERE reviews_id >= 0');
  }

  /// The method inserts a broadcaster into the database.
  ///
  /// [temp_satisfaction_rating], the users satisfaction rating given to the specific broadcaster.
  /// [temp_skill_rating], the users skill rating given to the specific broadcaster.
  /// [temp_entertainment_rating], the users entertainment rating given to the specific broadcaster.
  /// [temp_interaction_rating], the users interaction rating given to the specific broadcaster.
  /// [broadcaster_id], the broadcaster's id from the twitch api.
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
}
