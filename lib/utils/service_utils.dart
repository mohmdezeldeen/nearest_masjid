import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nearest_masjid/entities/masjid.dart';
import 'package:nearest_masjid/entities/result.dart';
import 'package:nearest_masjid/utils/database_helper.dart';

class ServiceUtils {
  static Future<bool> fetchResultFromServer(
      DatabaseHelper databaseHelper,
      double latitude,
      double longitude,
      int radius) async {
    var url = 'https://dev.prayer-now.com/api/v2/mosques?';
    await http
        .get(
            '${url}latitude=$latitude&longitude=$longitude&page=1&limit=10&radius=$radius')
        .then((response) {
      if (response.statusCode == 200) {
        ResponseResult responseResult =
            ResponseResult.fromJson(json.decode(response.body));
        List<Masjid> data = List();
        if (responseResult != null && responseResult.data != null) {
          data = responseResult.data;
          databaseHelper.deleteAllMasjids().then((deleted) async {
            for (Masjid masjid in data) {
              await databaseHelper.insertMasjid(masjid);
            }
            return true;
          });
        }
      } else {
        throw Exception('Failed to fetch nearest masjid');
      }
    }).catchError((error) {
      print('Error: $error');
      throw Exception(error);
    });
  }
}
