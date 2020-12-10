import 'dart:async' show Future;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:dbutils/sqllitedb.dart' show DBInterface;

/// The class for tags given by users to the broadcasters
class BroadcasterTag{

  int id;
  int userId;
  int broadcasterId;
  String tagName;

  /// The constructor for the broadcaster tag.
  ///
  /// [id], the primary key id for the tag.
  /// [tagName], the name of the tag.
  /// [broadcasterId], the foreign key relating to the broadcaster's id.
  BroadcasterTag({this.id, this.userId, this.tagName, this.broadcasterId});

  /// Maps the broadcaster tag object to a map object.
  Map<String, dynamic> toMap() {
    return {'tags_id': id, 'fk_tag_name': tagName, 'fk_broadcaster_id': broadcasterId, 'fk_user_id': userId};
  }
  /// Converts from a map to a broadcaster tag object.
  BroadcasterTag.fromMap(Map<String, dynamic> m) {
    id = m['tags_id'];
    tagName = m['fk_tag_name'];
    broadcasterId = m['fk_broadcaster_id'];
    userId = m['fk_user_id'];

  }

  // /// Converts from JSON to a broadcaster object.
  // User.fromJson(Map<String, dynamic> m) {
  //   id = m['_id'];
  //   email = m['email'];
  //   password = m['password'];
  //   phoneNumber = m['phone_number'];
  //   userName = m['user_name'];
  // }
  // /// Maps the broadcaster object to a Json object.
  // Map<String, dynamic> toJson() => {
  //   '_id': id,
  //   'email': email,
  //   'password': password,
  //   'phone_number': phoneNumber,
  //   'user_name': userName,
  // };
}

// int id;
// int userId;
// String tagName;
// int broadcasterId;
//
// /// The constructor for the broadcaster tag.
// ///
// /// [id], the primary key id for the tag.
// /// [tagName], the name of the tag.
// /// [broadcasterId], the foreign key relating to the broadcaster's id.
// BroadcasterTag({this.id, this.userId, this.tagName, this.broadcasterId});
//
// /// Maps the broadcaster tag object to a map object.
// Map<String, dynamic> toMap() {
//   return {'tags_id': id, 'tag_name': tagName, 'fk_broadcaster_id': broadcasterId};
// }
// /// Converts from a map to a broadcaster tag object.
// BroadcasterTag.fromMap(Map<String, dynamic> m) {
// id = m['tags_id'];
// tagName = m['tag_name'];
// broadcasterId = m['fk_broadcaster_id'];
// userId = m['fk_user_id'];
//
// }
