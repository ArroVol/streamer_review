import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/db.dart';
import 'package:streamer_review/model/user.dart';
import 'package:test/test.dart';
import 'package:streamer_review/helper/database_helper.dart';

void main() {
  test('title', () {

    // setup

    // run

    // verify

  });

  test('first test', () async {
    User newUser = new User();
    newUser.email = 'newEmail@gmail.com';
    newUser.phoneNumber = '7777777777';
    newUser.userName = 'new user guy';
    newUser.password = 'password123';
    await DBProvider.db.insertUser(newUser);
  });

}
