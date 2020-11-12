import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamer_review/model/Todo.dart';
import 'package:streamer_review/model/User.dart';


// import '../model/Todo.dart';

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'sr_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, content TEXT)");
        });
  }

  // initializeDatabase() async {
  //   return await openDatabase(join(await getDatabasesPath(), databaseName),
  //       version: 1, onCreate: (Database db, int version) async {
  //         await db.execute(
  //             "CREATE TABLE the_user(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, email TEXT, password TEXT)");
  //       });
  // }

  insertUser(User user) async {
    final db = await database;
    var res = await db.insert(Todo.TABLENAME, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<User>> retrieveUsers() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(User.TABLENAME);

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['user_id'],
       email: maps[i]['user_email'],
       password: maps[i]['content'],
      );
    });
  }

  updateUser(Todo todo) async {
    final db = await database;

    await db.update(Todo.TABLENAME, todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteUser(int id) async {
    var db = await database;
    db.delete(Todo.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }

  insertTodo(Todo todo) async {
    final db2 = await database;
    var res = await db2.insert(Todo.TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Todo>> retrieveTodos() async {
    final db2 = await database;

    final List<Map<String, dynamic>> maps2 = await db2.query(Todo.TABLENAME);

    return List.generate(maps2.length, (i) {
      return Todo(
        id: maps2[i]['id'],
        title: maps2[i]['title'],
        content: maps2[i]['content'],
      );
    });
  }

  updateTodo(Todo todo) async {
    final db2 = await database;

    await db2.update(Todo.TABLENAME, todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteTodo(int id) async {
    var db2 = await database;
    db2.delete(Todo.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }
}
