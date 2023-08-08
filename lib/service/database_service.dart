import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  Database? _database;
  static final DatabaseService _instance = DatabaseService();
  static DatabaseService get instance => _instance;

  init() async {
    _database = await openDatabase(
      "astp.db",
      version: 1,
      onCreate: (db, version) {
        db.execute("create table tiles(tileId TEXT, domain TEXT, primary key('tileId','domain'))");
      },
    );
  }

  Future<List<dynamic>> select(
      {required String table, String? where, List<dynamic>? args}) async {
    var data = await _database!.query("tiles", where: where, whereArgs: args, limit: 1);
    return data;
  }

  Future<int> insert(
      {required String table, required Map<String, dynamic> values}) async {
    var data = await _database!.insert("tiles", values);
    return data;
  }
}
