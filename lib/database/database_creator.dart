import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const Table_Name = 'nearest_masjid';
  static const id = 'id';
  static const name_en = 'name_en';
  static const name_ar = 'name_ar';
  static const address = 'address';
  static const latitude = 'latitude';
  static const longitude = 'longitude';
  static const images_url = 'images_url';
  static const distance = 'distance';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult,
      List<dynamic> params]) {
    print(functionName);
    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createNearestMasjidTable(Database db) async {
    final createQuery = '''CREATE TABLE $Table_Name
    (
      $id INTEGER PRIMARY KEY,
      $name_en TEXT,
      $name_ar TEXT,
      $address TEXT,
      $latitude REAL,
      $longitude REAL,
      $distance REAL,
      $images_url TEXT,
    )''';
    await db.execute(createQuery);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('nearest_masjid_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createNearestMasjidTable(db);
  }
}
