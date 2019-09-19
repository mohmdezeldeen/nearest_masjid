import 'dart:core';

class Masjid {
  final int id;
  final String name_en;
  final String name_ar;
  final String address;
  final double latitude;
  final double longitude;
  final String images_url;
  final double distance;

  Masjid(
      {this.id,
      this.name_en,
      this.name_ar,
      this.address,
      this.latitude,
      this.longitude,
      this.images_url,
      this.distance});

  factory Masjid.fromJson(Map json) {
    return Masjid(
        id: json['id'],
        name_en: json['name_en'],
        name_ar: json['name_ar'],
        address: json['address'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        images_url: json['images_url'],
        distance: json['distance']);
  }
}
