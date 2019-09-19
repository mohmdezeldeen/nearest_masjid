import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nearest_masjid/database/database_helper.dart';
import 'package:nearest_masjid/entities/masjid.dart';
import 'package:nearest_masjid/entities/result.dart';

class ServiceUtils {
  static Future<List<Masjid>> fetchResultFromServer(
      double latitude, double longitude, int radius) async {
    var url = 'https://dev.prayer-now.com/api/v2/mosques?';
    await http
        .get(
            '${url}latitude=$latitude&longitude=$longitude&page=1&limit=5&radius=$radius')
        .then((response) {
      if (response.statusCode == 200) {
        ResponseResult responseResult =
        ResponseResult.fromJson(json.decode(response.body));
        List<Masjid> data = List();
        if (responseResult != null && responseResult.data != null) {
          data = responseResult.data;
          _chacheDataToDatabase(data);
        }
        return data;
      } else {
        throw Exception('Failed to fetch nearest masjid');
      }
    }).catchError((error) {
      print('Error: $error');
      throw Exception(error);
    });
  }

  static void _chacheDataToDatabase(List<Masjid> data) async {
    await DatabaseHelper.deleteAll();
    for (Masjid masjid in data) {
      await DatabaseHelper.insertMasjid(masjid);
    }
  }
}
