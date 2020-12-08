import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/model/broadcaster_tag.dart';

///
/// The broadcaster tag repository class contains all basic CRUD methods.
class BroadcasterTagRepository {
  static final _TABLENAME = 'broadcaster_tags';

  /// This method adds a broadcaster tag to the database.
  ///
  /// [broadcasterTag], the specific name of the tag.
  Future<void> addBroadcasterTag(BroadcasterTag broadcasterTag) async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.insert(
      'broadcaster_tags',
      broadcasterTag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  //
  // Future<List<Map<String, dynamic>>> insertBroadcasterTag(
  //     broadcasterId, tagName) async {
  //   // get a reference to the database
  //   Database db = await DatabaseHelper2.instance.database;
  //
  //   // raw query
  //   List<Map> result = await db.rawQuery(
  //       'SELECT * FROM broadcaster_tags WHERE broadcaster_id=?',
  //       [broadcasterId]);
  //   await db.rawQuery(
  //       'INSERT INTO broadcaster_tags (tag_name, fk_broadcaster_id) VALUES(?, ?)',
  //       [tagName, broadcasterId]);
  //   // await db.rawQuery('UPDATE reviews SET satisfaction_rating = ?, entertainment_rating = ?, interactiveness_rating = ?, skill_rating = ? WHERE fk_broadcaster_id = ? AND fk_user_id = ?', [satisfaction_rating, entertainment_rating, interactiveness_rating, skill_rating, broadcaster_id, user_id]);
  //
  //   return result;
  // }

  Future<List<Map<String, dynamic>>> insertBroadcasterTag(
      broadcasterId, tagName, userId) async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;
    print("tagname: $tagName");
    String checkTag = tagName;
    bool tagExists = false;
    List<Map> res =  await db.rawQuery(
        'SELECT * FROM broadcaster_tags WHERE fk_broadcaster_id=? AND fk_user_id =?',
        [broadcasterId, userId]);
   List.generate(res.length, (i) {
      BroadcasterTag(
        id: res[i]['_id'],
        tagName: res[i]['fk_tag_name'],
        broadcasterId: res[i]['fk_broadcaster_id'],
        userId: res[i]['fk_user_id'],
      );
      if(checkTag == tagName && !tagExists){
        print("This tag already exists for this broadcaster: $broadcasterId by this user: $userId");
        tagExists = true;
      }
    });
   if(!tagExists) {
     List<Map> result = await db.rawQuery(
         'INSERT INTO broadcaster_tags (fk_tag_name, fk_broadcaster_id, fk_user_id) VALUES(?, ?, ?)',
         [tagName, broadcasterId, userId]);
     return result;
   }
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

  Future<List<Map<String, dynamic>>> selectAllTags() async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;
    // raw query
    // List<Map> result = await db.rawQuery(
    //     'SELECT * FROM broadcaster_tags'
    //    );
    return await db.query("broadcaster_tags");

    // return result;
  }

  Future<List<Map<String, dynamic>>> queryAllfromTagNames() async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;
    // raw query
    // List<Map> result = await db.rawQuery(
    //     'SELECT * FROM broadcaster_tags'
    //    );
    return await db.query("tag_names");

    // return result;
  }

  Future<List<Map<String, dynamic>>> selectAllBroadcastersByBroadcasterTag(
      tagName) async {
    // get a reference to the database
    Database db = await DatabaseHelper2.instance.database;

    // raw query
    List<Map> result = await db
        .rawQuery('SELECT * FROM broadcaster_tags WHERE fk_tag_name=?', [tagName]);
    // await db.rawQuery('UPDATE reviews SET satisfaction_rating = ?, entertainment_rating = ?, interactiveness_rating = ?, skill_rating = ? WHERE fk_broadcaster_id = ? AND fk_user_id = ?', [satisfaction_rating, entertainment_rating, interactiveness_rating, skill_rating, broadcaster_id, user_id]);
    return result;
  }
}
