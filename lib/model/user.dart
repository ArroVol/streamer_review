import 'dart:async' show Future;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:dbutils/sqllitedb.dart' show DBInterface;



class User extends DBInterface{
  int id;
  String email;
  String password;
  static const String TABLENAME = "the_user";

  // User(this.id, this.email, this.password, {id, password, email});
  User({this.id, this.email, this.password});

  // User(int id, String email, String password){
  //   this.id = id;
  //   this.email = email;
  //   this.password = password;
  // }

  User.fromJson(Map<String, dynamic> m) {
    id = m['user_id'];
    email = m['user_email'];
    password = m['user_password'];
  }

  // int get id => id;
  //
  // String get email => email;
  //
  // String get password => password;

  Map<String, dynamic> toJson() => {
    'user_id': id,
    'user_email': email,
    'user_password': password,
  };

  Map<String, dynamic> toMap() {
    return {'user_id': id, 'user_email': email, 'user_password': password};
  }

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute("""
     CREATE TABLE the_user(
              user_id INTEGER PRIMARY KEY
              ,user_email TEXT
              ,user_password TEXT
              )
     """);
  }

  @override
  get version => 1;

  @override
  // TODO: implement name
  String get name => 'a_user';


  //
  // @override
  // get name => 'testing.db';
}
