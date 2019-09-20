import 'dart:convert';
import 'dart:core';

class Masjid {
  int id;
  String name_en;
  String name_ar;
  String address;
  double latitude;
  double longitude;
  double distance;

  Masjid(
      {this.id,
      this.name_en,
      this.name_ar,
      this.address,
      this.latitude,
      this.longitude,
      this.distance});

  factory Masjid.fromJson(Map<String, dynamic> json) => Masjid(
      id: json['id'],
      name_en: json['name_en'],
      name_ar: json['name_ar'],
      address: json['address'],
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      distance: json['distance'] as double);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name_en": name_en,
        "name_ar": name_ar,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance
      };
}
