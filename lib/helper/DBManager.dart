
import 'package:sqflite/sqflite.dart';

import 'item.dart';

class DBManager {
  static final DBManager _instance = DBManager._internal();
  _DBHolder _holder; // an holder for getting the database

  Future<Database> _db;

  Future<Database> get db async {
    if (_db == null) {
      print('its null)');
      // initialize database
    }
    return _db;
  }
  factory DBManager() {
    return _instance;
  }

  DBManager._internal() {
    _holder = _DBHolder();
  }

  Future<void> deleteDb() async {
    final Database db = await _holder.db;
    // delete database
  }

  Future<void> insertItem(Item i) async {
    final Database db = await _holder.db;
    // insert item
  }

  Future<void> updateItem(Item i) async {}
  Future<void> deleteItem(int id) async {}
  Future<List<Item>> items() async {
    Future<List<Item>> itemList;
    return itemList;
  }
}

class _DBHolder {
  Future<Database> _db;

  Future<Database> get db async {
    if (_db == null) {
      // initialize database
    }
    return _db;
  }

}
