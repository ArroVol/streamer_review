import 'dart:async' show Future;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:dbutils/sqllitedb.dart' show DBInterface;

class BroadcasterTag{

  int id;
  String tagName;
  int broadcasterId;

  BroadcasterTag({this.id, this.tagName, this.broadcasterId});

  Map<String, dynamic> toMap() {
    return {'tags_id': id, 'tag_name': tagName, 'fk_broadcaster_id': broadcasterId};
  }

  BroadcasterTag.fromMap(Map<String, dynamic> m) {
    id = m['tags_id'];
    tagName = m['tag_name'];
    broadcasterId = m['fk_broadcaster_id'];
  }
}
