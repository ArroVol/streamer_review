import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:streamer_review/helper/db.dart';
import 'package:streamer_review/model/user.dart';
import 'package:test/test.dart';

void main() {
  Database database;
  WidgetsFlutterBinding.ensureInitialized();
  test('first test', () async {
    User newUser = new User();
    newUser.email = 'newEmail@gmail.com';
    newUser.phoneNumber = '7777777777';
    newUser.userName = 'new user guy';
    newUser.password = 'password123';
    DBProvider.db.insertUser(newUser);

  });
}

