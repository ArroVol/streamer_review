import 'dart:async' show Future;
import 'package:sqflite/sqflite.dart' show Database;
import 'package:dbutils/sqllitedb.dart' show DBInterface;

///The broadcaster class that converts data from objects from and to JSON.
///
/// Extends the DBInterface to create the broadcaster table in SQlite.
class Broadcaster extends DBInterface{
  int id;
  String broadcasterID;
  String broadcasterName;
  var overallSatisfaction;
  var overallSkill;
  var overallEntertainment;
  var overallInteractiveness;
  static const String TABLENAME = "broadcaster_table";


  /// The Broadcaster constructor.
  ///
  /// [id] the primary key for the broadcaster.
  /// [broadcasterID] the broadcaster's id.
  /// [broadcasterName] the broadcaster's channel name.
  // Broadcaster({this.id, this.broadcasterID, this.broadcasterName});

  Broadcaster({this.id, this.broadcasterID, this.broadcasterName, this.overallSatisfaction, this.overallSkill, this.overallEntertainment, this.overallInteractiveness});


  /// Converts from JSON to a broadcaster object.
  Broadcaster.fromJson(Map<String, dynamic> m) {
    id = m['user_id'];
    broadcasterID = m['broadcasterID'];
    broadcasterName = m['broadcasterName'];
  }
  /// Maps the broadcaster object to a Json object.
  Map<String, dynamic> toJson() => {
    'id': id,
    'broadcaster_id': broadcasterID,
    'broadcaster_name': broadcasterName,
  };

  /// Creates the broadcaster table in the SQLite database.
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

  /// Returns the version of the database.
  @override
  get version => 1;

  /// Gets the name of the broadcaster.
  @override
  String get name => 'a_broadcaster';


}
