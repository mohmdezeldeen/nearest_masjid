import 'dart:convert';

import 'masjid.dart';

class ResponseResult {
  final List<Masjid> data;

  ResponseResult({this.data});

  factory ResponseResult.fromJson(Map<String, dynamic> parsedJson) {
    var dataFromJson = parsedJson['data'];
    var mapList = List<Map>.from(dataFromJson);
    List<Masjid> masjidList = List();
    for (Map m in mapList) {
      masjidList.add(Masjid.fromJson(m));
    }
    return ResponseResult(data: masjidList);
  }
}
