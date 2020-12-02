import 'DBManager.dart';

// @Skip("sqflite cannot run on the machine")

void main() {
  setUp(() async {
    // clean up db before every test
    await DBManager().deleteDb();
  });

  tearDownAll(() async {
    // clean up db after all tests
    await DBManager().deleteDb();
  });

    test('Insert items', () async {
      // at the beginning database is empty
      expect((await DBManager().items()).isEmpty, true);

      // insert one empty item
      DBManager().insertItem(Item.empty());
      expect((await DBManager().items()).length, 1);

      // insert more empty items
      DBManager().insertItem(Item.empty());
      DBManager().insertItem(Item.empty());
      DBManager().insertItem(Item.empty());
      expect((await DBManager().items()).length, 1);

      // insert a valid item
      DBManager().insertItem(Item.fromMap(myMap1));
      expect((await DBManager().items()).length, 2);
      // insert few times more the same item
      DBManager().insertItem(Item.fromMap(myMap1));
      DBManager().insertItem(Item.fromMap(myMap1));
      DBManager().insertItem(Item.fromMap(myMap1));
      expect((await DBManager().items()).length, 2);

      // insert other valid items
      DBManager().insertItem(Item.fromMap(myMap2));
      DBManager().insertItem(Item.fromMap(myMap3));
      DBManager().insertItem(Item.fromMap(myMap4));
      expect((await DBManager().items()).length, 5);
    });

    test('Update items', () async {});
    test('Delete items', () async {});
    test('Retrieve items', () async {});
    test('Delete database', () async {});
  }
