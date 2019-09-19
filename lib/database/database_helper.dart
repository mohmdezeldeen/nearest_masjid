import 'package:nearest_masjid/entities/masjid.dart';

import 'database_creator.dart';

class DatabaseHelper {
  static Future<List<Masjid>> getAllMasjids() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.Table_Name}''';
    final data = await db.rawQuery(sql);
    List<Masjid> masjidsList = List();

    for (final node in data) {
      final masjid = Masjid.fromJson(node);
      masjidsList.add(masjid);
    }
    return masjidsList;
  }

  static Future<Masjid> getMasjidsById(int id) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.Table_Name}
    WHERE ${DatabaseCreator.id} = ?''';
    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);
    final masjid = Masjid.fromJson(data.first);
    return masjid;
  }

  static Future<void> insertMasjid(Masjid masjid) async {
    final sql = '''INSERT INTO ${DatabaseCreator.Table_Name}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.name_en},
      ${DatabaseCreator.name_ar},
      ${DatabaseCreator.address},
      ${DatabaseCreator.latitude},
      ${DatabaseCreator.longitude},
      ${DatabaseCreator.distance},
      ${DatabaseCreator.images_url}
    )
    VALUES (?,?,?,?,?,?,?,?)''';
    List<dynamic> params = [
      masjid.id,
      masjid.name_en,
      masjid.name_ar,
      masjid.address,
      masjid.latitude,
      masjid.longitude,
      masjid.distance,
      masjid.images_url
    ];
    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('insertMasjid', sql, null, result, params);
  }

  static Future<void> deleteAll() async {
    final sql = '''DELETE FROM ${DatabaseCreator.Table_Name}''';
    final result = await db.rawDelete(sql);
    DatabaseCreator.databaseLog('deleteAll', sql, null, result, null);
  }

  static Future<int> masjidsCount() async {
    final data = await db
        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.Table_Name}''');
    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
