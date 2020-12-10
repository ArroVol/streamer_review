/// The class for the favorites created by the user for a broadcaster
///
/// @version 1.0
class Favorites {
  int favoritesId;
  int broadcasterId;
  int userId;

  static const String TABLENAME = "favoritess";

  /// The favorites constructor
  ///
  /// [favoritesId], the primary key id for the favorites.
  /// [broadcasterId], the primary key id for the favorites.
  /// [userId], the primary key id for the favorites.
  Favorites(
      {this.favoritesId, this.broadcasterId, this.userId});

  /// Maps the favorites object to a map object.
  Map<String, dynamic> toMap() {
    return {'favorites_id': favoritesId,  'fk_broadcaster_id':broadcasterId , 'fk_user_id':userId};
  }

  /// Maps the favorites object to a map object.
  Favorites.fromMap(Map<String, dynamic> m) {
    favoritesId = m['favorites_id'];
    broadcasterId = m['fk_broadcaster_id'];
    userId = m['fk_user_id'];
  }

}
