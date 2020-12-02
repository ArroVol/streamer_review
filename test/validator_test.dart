// import 'package:login_demo/login_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();


  test('return the database', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // var db = await openDatabase('myDatabase24.db');

    // final result = EmailFieldValidator.validate('');
    // expect(result, 'Email can\'t be empty');
    // Database db2 = await DatabaseHelper2.instance.database;
    // List<Map> result = await db.rawQuery(
    //     'SELECT * FROM broadcaster_table WHERE broadcaster_id=?',
    //     [2224]);
    // print(db.path);
  });

  test('non-empty email returns null', () async {

    var db = await openDatabase('myDatabase24.db');

    // final result = EmailFieldValidator.validate('email');
    // expect(result, null);
  });

  test('empty password returns error string', () {

    // final result = PasswordFieldValidator.validate('');
    // expect(result, 'Password can\'t be empty');
  });

  test('non-empty password returns null', () {

    // final result = PasswordFieldValidator.validate('password');
    // expect(result, null);
  });
}
