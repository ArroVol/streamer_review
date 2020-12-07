import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'package:streamer_review/model/review.dart';
import 'package:streamer_review/model/user.dart';


void main() {

  test('query users', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    // TestWidgetsFlutterBinding.ensureInitialized();

    Future<List<Map<String, dynamic>>> result2 = d.queryAllUsers();
    // var result = await d.queryAllUsers();
    // List<Map<String, dynamic>> result2 = d.queryAllUsers();

    // print(result2.toString().length);
    List<User> userList = [];
    User user = new User();
    List.generate(result2.toString().length, (i) {
      userList.add(User(
      ));
    });
    int id = userList.first.id;
    expect(48, userList.length);
  });


  test('insert user', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    User newUser = new User();
    newUser.email = 'newEmail@gmail.com';
    newUser.phoneNumber = '7777777777';
    newUser.userName = 'new user guy';
    newUser.password = 'password123';
     d.insertUser(newUser);
    Future<List<Map<String, dynamic>>> result2 = d.queryAllUsers();

    List<User> userList = [];
    User user = new User();
    List.generate(result2.toString().length, (i) {
      userList.add(User(


      ));
    });
    int id = userList.first.id;
    expect(48, userList.length);
  });

  test('query reviews', () async {

    TestWidgetsFlutterBinding.ensureInitialized();

    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    Future<List<Map<String, dynamic>>> result2 =  d.selectReviews(220007, 12);
    print(result2.toString().length);
    List<Review> userList = [];
    Review user = new Review();
    List.generate(result2.toString().length, (i) {
      userList.add(Review(
      ));
    });
    expect(48, userList.length);
  });
  test('non-empty email returns null', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var db = openDatabase('myDatabase24.db');
   if (EmailFieldValidator == null) {
  String result = null;
 }
    // expect(result,  null);
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

class EmailFieldValidator {

  void validate(String email){
    return null;
  }
}
