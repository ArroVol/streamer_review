import 'dart:ffi';
import 'package:sqlite3/src/api/result_set.dart';


/// An opened sqlite3 database.
abstract class Database {
  /// The application defined version of this database.
  int get userVersion;
  set userVersion(int version);

  /// Returns the row id of the last inserted row.
  int get lastInsertRowId;

  /// The native database connection handle from sqlite.
  ///
  /// This returns a pointer towards the opaque sqlite3 structure as defined
  /// [here](https://www.sqlite.org/c3ref/sqlite3.html).
  Pointer<void> get handle;

  /// The amount of rows affected by the last `INSERT`, `UPDATE` or `DELETE`
  /// statement.
  int getUpdatedRows();

  /// Executes the [sql] statement and ignores the result.
  void execute(String sql);

  /// Prepares the [sql] select statement and runs it with the provided
  /// [parameters].
  ResultSet select(String sql, [List<Object> parameters]);



  /// Creates a scalar function that can be called from sql queries sent against
  /// this database.
  ///
  /// The [functionName] defines the (case insensitive) name of the function in
  /// sql. The utf8 encoding of [functionName] must not exceed a length of 255
  /// bytes.
  ///
  /// {@template sqlite3_function_flags}
  /// The [argumentCount] parameter can be used to declare how many arguments a
  /// function supports. If you need a function that can use multiple argument
  /// counts, you can call [createFunction] multiple times.
  /// The [deterministic] flag (defaults to `false`) can be set to indicate that
  /// the function always gives the same output when the input parameters are
  /// the same. This is a requirement for functions that are used in generated
  /// columns or partial indexes. It also allows the query planner for optimize
  /// by factoring invocations out of inner loops.
  /// The [directOnly] flag (defaults to `true`) is a security measure. When
  /// enabled, the function may only be invoked form top-level SQL, and cannot
  /// be used in VIEWs or TRIGGERs nor in schema structures (such as CHECK,
  /// DEFAULT, etc.). When [directOnly] is set to `false`, the function might
  /// be invoked when opening a malicious database file. sqlite3 recommends
  /// this flag for all application-defined functions, especially if they have
  /// side-effects or if they could potentially leak sensitive information.
  /// {@endtemplate}
  ///
  /// The [function] can be any Dart closure, it's not restricted to functions
  /// that would be supported by [Pointer.fromFunction]. For more details on how
  /// the sql function behaves, see the documentation on [ScalarFunction].
  ///
  /// For more information, see https://www.sqlite.org/appfunc.html.



  /// Closes this database and releases associated resources.
  void dispose();
}
