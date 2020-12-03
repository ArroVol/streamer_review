// import 'package:login_demo/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'package:streamer_review/model/review.dart';
import 'package:streamer_review/model/user.dart';

import 'package:streamer_review/widgets/anotherMain.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  // runApp(MyApp());

  test('query users', () async {
    // WidgetsFlutterBinding.ensureInitialized();
    // TestWidgetsFlutterBinding.ensureInitialized();
    // runApp(MyApp());
    TestWidgetsFlutterBinding.ensureInitialized();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    // TestWidgetsFlutterBinding.ensureInitialized();
    // Future<List<Map<String, dynamic>>> result = d.queryAllUsers();
    // var result = await d.queryAllUsers();
    List<Map<String, dynamic>> result2 = await d.queryAllUsers();

    print(result2.toString().length);
    List<User> userList = [];
    User user = new User();
    List.generate(result2.toString().length, (i) {
      userList.add(User(
        // id: user[i]['_id'],
        // email: user[i]['email'],
        // password: user[i]['password'],
        // userName: user[i]['user_name'],
        // phoneNumber: user[i]['phone_number'],
      ));
    });
   print(userList.length);
    int id = userList.first.id;
    print(id);
    // for(var x in result2){
    //   print(x);
    // }
    print(result2);
    expect(48, userList.length);

    // var db = await openDatabase('myDatabase24.db');

    // final result = EmailFieldValidator.validate('');
    // expect(result, 'Email can\'t be empty');
    // Database db2 = DatabaseHelper2.instance;
    // List<Map> result = await db.rawQuery(
    //     'SELECT * FROM broadcaster_table WHERE broadcaster_id=?',
    //     [2224]);
    // print(db.path);
  });


  test('insert user', () async {
    TestWidgetsFlutterBinding.ensureInitialized();


    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    User newUser = new User();
    newUser.email = 'newEmail@gmail.com';
    newUser.phoneNumber = '7777777777';
    newUser.userName = 'new user guy';
    newUser.password = 'password123';
   await d.insertUser(newUser);
    List<Map<String, dynamic>> result2 = await d.queryAllUsers();

    print(result2.toString().length);
    List<User> userList = [];
    User user = new User();
    List.generate(result2.toString().length, (i) {
      userList.add(User(


      ));
    });
    print(userList.length);
    int id = userList.first.id;
    print(id);

    print(result2);
    expect(48, userList.length);
  });

  test('query reviews', () async {

    TestWidgetsFlutterBinding.ensureInitialized();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    List<Map<String, dynamic>> result2 = await d.selectReviews(220007, 12);
    print(result2.toString().length);
    List<Review> userList = [];
    Review user = new Review();
    List.generate(result2.toString().length, (i) {
      userList.add(Review(
      ));
    });
    print(userList.length);
    // int id = userList.first.id;
    // print(id);
    print(result2);
    expect(48, userList.length);
  });
  test('non-empty email returns null', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var db = openDatabase('myDatabase24.db');
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
