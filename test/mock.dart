
import 'package:flutter_test/flutter_test.dart';
import 'package:streamer_review/helper/database_helper.dart';
// import 'package:sqlcool/sqlcool.dart';
// import 'base.dart';

import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'package:http/http.dart' as http;
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseHelper2.instance.database;
  group("init", () {
    TestWidgetsFlutterBinding.ensureInitialized();
    test("Init db", () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;

    });
  });
}
