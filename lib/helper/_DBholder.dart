import 'package:sqflite/sqflite.dart';

class _DBHolder {
  Future<Database> _db;

  Future<Database> get db async {
    if (_db == null) {
      // initialize database
    }
    return _db;
  }
}
