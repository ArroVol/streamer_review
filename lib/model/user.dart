import 'dart:async' show Future;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:dbutils/sqllitedb.dart' show DBInterface;

class User extends DBInterface{
  int id;
  String email;
  String password;
  String phoneNumber;
  String userName;

  static const String TABLENAME = "_user_table";

  // User(this.id, this.email, this.password, {id, password, email});
  User({this.id, this.email, this.password, this.userName, this.phoneNumber});

  User.fromJson(Map<String, dynamic> m) {
    id = m['_id'];
    email = m['email'];
    password = m['password'];
    phoneNumber = m['phone_number'];
    userName = m['user_name'];
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'password': password,
    'phone_number': phoneNumber,
    'user_name': userName,
  };

  Map<String, dynamic> toMap() {
    return {'_id': id, 'email': email, 'password': password, 'phone_number': phoneNumber, 'user_name':userName};
  }

  User.fromMap(Map<String, dynamic> m) {
    id = m['_id'];
    email = m['email'];
    password = m['password'];
    phoneNumber = m['phone_number'];
    userName = m['user_name'];
  }

  // factory User.fromMap(Map<String, dynamic> json) => new User(
  //   id: json["id"],
  //   firstName: json["first_name"],
  //   lastName: json["last_name"],
  //   blocked: json["blocked"] == 1,
  // );
  // Map<String, dynamic> toMap() {
  //   return {'user_id': id, 'user_email': email, 'user_password': password};
  // }
  // User(int id, String email, String password){
  //   this.id = id;
  //   this.email = email;
  //   this.password = password;
  // }

  // User.fromJson(Map<String, dynamic> m) {
  //   id = m['user_id'];
  //   email = m['user_email'];
  //   password = m['user_password'];
  // }

  // int get id => id;
  //
  // String get email => email;
  //
  // String get password => password;

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
