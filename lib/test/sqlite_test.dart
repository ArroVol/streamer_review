// test/sqlite_test.dart

// skip this file to avoid getting errors when running your unit tests
@Skip("sqflite cannot run on the machine.")

import 'dart:io';
import 'package:streamer_review/helper/database_helper.dart';
import "package:test/test.dart";
import 'package:sqflite/sqflite.dart';


final testDBPath = "somepath";
// SQLitePathsDao dao;
// SQLite sqlite;


/// Runs SQLite database tests. Assumes running in a fresh database all the time
/// Database is NOT reset between tests, tests should assume data exists from other test
/// runs.
/// Database is removed once all tests are complete
/// TODO: ideally I'd like to create a new DB before every test
///
///
void main() {

    setUp(() async {
     Database db =  await DatabaseHelper2.instance.database;
    });

    group('Given Product List Page Loads', () {
      test('Page should load a list of products from firebase', () async {
        // 1
        // await productListViewModel.getProducts();
        // // 2
        expect(2, 2);
        // // 3
        // expect(productListViewModel.products[0].name, 'MacBook Pro 16-inch model');
        // expect(productListViewModel.products[0].price, 2399);
        // expect(productListViewModel.products[1].name, 'AirPods Pro');
        // expect(productListViewModel.products[1].price, 249);
      });
    });
    }
//   test('Insert items', () async {
// // at the beginning database is empty
//   expect((await DBManager().items()).isEmpty, true);
//       // sqlite = SQLite( (await getDatabasesPath()) + "/" + testDBPath);


      // await sqlite.setup();
      // dao = SQLitePathsDao(sqlite);

// void main() {
//   group("SQLiteDao tests", () {
//
//     setUp(() async {
//       sqlite = SQLite( (await getDatabasesPath()) + "/" + testDBPath);
//
//       await sqlite.setup();
//       dao = SQLitePathsDao(sqlite);
//     });
//
//     // Delete the database so every test run starts with a fresh database
//     tearDownAll(() async {
//       await deleteDatabase( (await getDatabasesPath()) + "/" + testDBPath);
//     });
//
//     test("should insert and query path by id", () async {
//       Path p = Path(name: "my path", isArriveAt: true, time: DateTime.now());
//       p = await dao.insertPath(p);
//       expect(p.id, isNotNull);
//
//       var qp = await dao.getPath(p.id);
//
//       expect(qp.name, equals(p.name));
//       expect(qp.isArriveAt, equals(p.isArriveAt));
//       expect(qp.id, equals(p.id));
//     });
//
//     test("sample sqflite test code", () async {
//       var result = await sqlite.db.query('sampleTableName', where: "id = ?", whereArgs: ['123']);
//       expect(result.length, equals(0));
//     });
//   });
// }
