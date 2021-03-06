// import 'package:streamer_review/helper/item.dart';
// import 'package:streamer_review/helper/DBManager.dart';
//
// // import 'DBManager.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// // import 'item.dart';
// // @Skip("sqflite cannot run on the machine")
//
// void main() {
//   Item emptyItem = new Item();
//   setUp(() async {
//     // clean up db before every test
//     await DBManager().deleteDb();
//   });
//
//   tearDownAll(() async {
//     // clean up db after all tests
//     await DBManager().deleteDb();
//   });
//
//   group('DBManager', () {
//     test('Insert items', () async {
//       // at the beginning database is empty
//       expect((await DBManager().items()).isEmpty, true);
//
//       // insert one empty item
//       DBManager().insertItem(emptyItem);
//       expect((await DBManager().items()).length, 1);
//
//       // insert more empty items
//       DBManager().insertItem(emptyItem);
//       DBManager().insertItem(emptyItem);
//       DBManager().insertItem(emptyItem);
//       expect((await DBManager().items()).length, 1);
//
//       // insert a valid item
//       // DBManager().insertItem(Item.fromMap(myMap1));
//       expect((await DBManager().items()).length, 2);
//       // insert few times more the same item
//       // DBManager().insertItem(Item.fromMap(myMap1));
//       // DBManager().insertItem(Item.fromMap(myMap1));
//       // DBManager().insertItem(Item.fromMap(myMap1));
//       expect((await DBManager().items()).length, 2);
//
//       // insert other valid items
//       // DBManager().insertItem(Item.fromMap(myMap2));
//       // DBManager().insertItem(Item.fromMap(myMap3));
//       // DBManager().insertItem(Item.fromMap(myMap4));
//       expect((await DBManager().items()).length, 5);
//     });
//
//     test('Update items', () async {});
//     test('Delete items', () async {});
//     test('Retrieve items', () async {});
//     test('Delete database', () async {});
//   });
// }
//
