import 'dart:async' show Future;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:dbutils/sqllitedb.dart' show DBInterface;

/// The class for tags given by users to the broadcasters
///
class BroadcasterTag{

  int id;
  String tagName;
  int broadcasterId;

  /// The constructor for the broadcaster tag.
  ///
  /// [id], the primary key id for the tag.
  /// [tagName], the name of the tag.
  /// [broadcasterId], the foreign key relating to the broadcaster's id.
  BroadcasterTag({this.id, this.tagName, this.broadcasterId});

  /// Maps the broadcaster tag object to a map object.
  Map<String, dynamic> toMap() {
    return {'tags_id': id, 'tag_name': tagName, 'fk_broadcaster_id': broadcasterId};
  }
  /// Converts from a map to a broadcaster tag object.
  BroadcasterTag.fromMap(Map<String, dynamic> m) {
    id = m['tags_id'];
    tagName = m['tag_name'];
    broadcasterId = m['fk_broadcaster_id'];
  }
}
