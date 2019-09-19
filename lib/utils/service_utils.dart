import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nearest_masjid/entities/result.dart';

class ServiceUtils {
  static Future<ResponseResult> fetchResultFromServer(
      double latitude, double longitude, int radius) async {
    var url = 'https://dev.prayer-now.com/api/v2/mosques?';
    await http.get(
            '${url}latitude=$latitude&longitude=$longitude&page=1&limit=5&radius=$radius')
        .then((response) {
      if (response.statusCode == 200) {
        return ResponseResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch nearest masjid');
      }
    }).catchError((error) {
      print('Error: $error');
      throw Exception(error);
    });
  }
}
