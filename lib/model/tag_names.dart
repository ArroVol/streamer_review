import 'dart:async' show Future;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:dbutils/sqllitedb.dart' show DBInterface;

/// The class for tags given by users to the broadcasters
///
class TagNames{

  int id;
  String tagName;

  /// The constructor for the broadcaster tag.
  ///
  /// [id], the primary key id for the tag.
  /// [tagName], the name of the tag.
  TagNames({this.id, this.tagName});

  /// Maps the broadcaster tag object to a map object.
  Map<String, dynamic> toMap() {
    return {'tags_id': id, 'tag_name': tagName};
  }
  /// Converts from a map to a broadcaster tag object.
  TagNames.fromMap(Map<String, dynamic> m) {
    id = m['tags_id'];
    tagName = m['tag_name'];

  }
}
