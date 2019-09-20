import 'dart:async';
import 'dart:io';

import 'package:nearest_masjid/entities/masjid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String tableMasjid = 'nearest_masjid';
  String colId = 'id';
  String colNameAr = 'name_ar';
  String colNameEn = 'name_en';
  String colAddress = 'address';
  String colLatitude = 'latitude';
  String colLongitude = 'longitude';
  String colDistance = 'distance';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'nearest_masjid.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableMasjid($colId INTEGER PRIMARY KEY, $colNameAr TEXT, '
        '$colNameEn TEXT, $colLatitude REAL, $colLongitude REAL, $colDistance REAL, $colAddress TEXT)');
  }

  Future<List<Map<String, dynamic>>> _getMasjidMapList() async {
    Database db = await this.database;
    var result = await db.query(tableMasjid);
    return result;
  }

  Future<int> insertMasjid(Masjid masjid) async {
    Database db = await this.database;
    var result = await db.insert(tableMasjid, masjid.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateMasjid(Masjid masjid) async {
    var db = await this.database;
    var result = await db.update(tableMasjid, masjid.toMap(),
        where: '$colId = ?', whereArgs: [masjid.id]);
    return result;
  }

  Future<int> deleteMasjid(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tableMasjid WHERE $colId = $id');
    return result;
  }

  Future<int> deleteAllMasjids() async {
    var db = await this.database;
    int result =
    await db.rawDelete('DELETE FROM $tableMasjid');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableMasjid');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Masjid>> getMasjidList() async{
    var masjidMapList = await _getMasjidMapList();
    int count = masjidMapList.length;
    List<Masjid> masjidList = List<Masjid>();
    for (int i = 0; i < count; i++) {
      masjidList.add(Masjid.fromJson(masjidMapList[i]));
    }
    return masjidList;
  }
}
