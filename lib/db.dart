import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  String tableName = 'favorites';
  String columnFavorite = 'favorite';

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "coupons1.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableName ("
          "$columnFavorite TEXT PRIMARY KEY"
          ")");
    });
  }

  newEntry(String favorite) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into $tableName ($columnFavorite)"
        " VALUES (?)",
        [favorite]);

    return raw;
  }

  check(String favorite) async {
    final db = await database;

    List<String> list;
    await db
        .query(tableName,
            columns: [columnFavorite], where: "$columnFavorite = '$favorite'")
        .then((data) {
      List<Map<String, dynamic>> s = data;
      list = new List();
      for (var x in s) {
        x.forEach((k, v) => list.add(v));
        //list.add(x.toString());
        print(x);
      }
    });
    return list.length;
  }

  deleteEntry(String favorite) async {
    final db = await database;
    db.delete(tableName, where: "$columnFavorite = '$favorite'");
  }

  getAllFavorites() async {
    final db = await database;
    List<String> list;
    await db.query(tableName, columns: [columnFavorite]).then((data) {
      List<Map<String, dynamic>> s = data;
      list = new List();
      for (var x in s) {
        x.forEach((k, v) => list.add(v));
        //list.add(x.toString());
        print(x);
      }
    });
    return list;
  }
}
