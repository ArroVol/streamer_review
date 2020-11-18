import 'dart:async' show Future;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:dbutils/sqllitedb.dart' show DBInterface;



class Broadcaster extends DBInterface{
  int id;
  String broadcasterID;
  String broadcasterName;
  static const String TABLENAME = "broadcaster";

  // User(this.id, this.email, this.password, {id, password, email});
  Broadcaster({this.id, this.broadcasterID, this.broadcasterName});



  Broadcaster.fromJson(Map<String, dynamic> m) {
    id = m['user_id'];
    broadcasterID = m['broadcasterID'];
    broadcasterName = m['broadcasterName'];
  }
  

  Map<String, dynamic> toJson() => {
    'id': id,
    'broadcaster_id': broadcasterID,
    'broadcaster_name': broadcasterName,
  };

  // Map<String, dynamic> toMap() {
  //   return {'user_id': id, 'user_email': broadcasterID, 'user_password': password};
  // }

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute("""
     CREATE TABLE broadcaster(
              id INTEGER PRIMARY KEY
              ,broadcasterID TEXT
              ,broadcasterName TEXT
              )
     """);
  }

  @override
  get version => 1;

  @override
  // TODO: implement name
  String get name => 'a_broadcaster';


//
// @override
// get name => 'testing.db';
}
