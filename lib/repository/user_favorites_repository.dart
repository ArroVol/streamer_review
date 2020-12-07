import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';

/// The repository for the data for the user's favorite broadcasters
class UserFavoritesRepository {
  static final _TABLENAME = "user_favorites";
  final SecureStorage secureStorage = SecureStorage();

  /// This method inserts the data for a favorite broadcaster into the database.
  ///
  /// [broadcaster_id], the broadcasters id from twitch.
  /// [async], synchronizes with the database.
  Future<void> insertFavorite(int broadcasterId) async {
    Database db = await DatabaseHelper2.instance.database;
    // Gets the user's email that is logged in from the phone's storage.
    String userEmail = await secureStorage.readSecureData("email");
    int userId = await DatabaseHelper2.instance.getUserIdByEmail(userEmail);
    print("**inserting favorite: $userId**");

    await db.rawQuery(
        'INSERT INTO user_favorites (fk_broadcaster_id, fk_user_id) VALUES(?, ?)',
        [broadcasterId, userId]);
  }

  /// This method inserts the data for a favorite broadcaster into the database.
  ///
  /// [broadcaster_id], the broadcasters id from twitch.
  /// [async], synchronizes with the database.
  Future<int> deleteFavorite(int broadcasterId) async {
    print("in the delete method for favorite in the database");
    Database db = await DatabaseHelper2.instance.database;
    String userEmail = await secureStorage.readSecureData("email");
    int userId = await DatabaseHelper2.instance.getUserIdByEmail(userEmail);

    int deletedRow = await db.delete('user_favorites',
        where: 'fk_broadcaster_id = ?', whereArgs: [broadcasterId]);
    return deletedRow;
  }

  /// This method queries all favorites by the user who is currently logged in.
  Future<List<Map<String, dynamic>>> queryAllFavoritesByUserLoggedIn() async {
    Database db = await DatabaseHelper2.instance.database;
    String userEmail = await secureStorage.readSecureData("email");
    int userId = await DatabaseHelper2.instance.getUserIdByEmail(userEmail);
    return await db
        .query('user_favorites', where: 'fk_user_id = ?', whereArgs: [userId]);
  }

  /// This method queries all favorites by the user id specified to the method.
  Future<List<Map<String, dynamic>>> queryAllFavoritesByUserSpecified(int userId) async {
    Database db = await DatabaseHelper2.instance.database;
    return await db
        .query('user_favorites', where: 'fk_user_id = ?', whereArgs: [userId]);
  }

  //Query returns a list of map (must be passed as a type)
  //All data will be in the form of map, so it returns a list of map
  /// This method queries all favorites from the favorites table in the database.
  Future<List<Map<String, dynamic>>> queryAllFavorites() async {
    Database db = await DatabaseHelper2.instance.database;
    return await db.query("user_favorites");
  }


// //to update you need to pass the id of which will be updated as well as pass the value
// // takes in a map type parameter
// Future<int> updateFavorite(int broadcasterId) async {
//   print("in the update method for favorite in the database");
//   Database db = await DatabaseHelper2.instance.database;
//   // List<User> newUser = await getUserByUserName(user.userName);
//   // int id = newUser.first.id;
//   // List<Map<String, dynamic >> user = await db.query('_user_table', where: '_id = ?', whereArgs: []);
//   String userEmail = await secureStorage.readSecureData("email");
//   int userId = await DatabaseHelper2.instance.getUserIdByEmail(userEmail);
//   int updatedCount = await db.rawUpdate('''
//   UPDATE user_favorites
//   SET fk_broadcaster_id = ?, fk_user_id = ?
//   WHERE _id = ?
//   ''', [broadcasterId, user.password, user.userName, user.phoneNumber, id]);
//   return updatedCount;
// }

}
