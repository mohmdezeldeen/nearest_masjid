import 'package:geolocator/geolocator.dart';

class LocationUtils {
  static const String LOCATION_UTILS_ERROR = "geolocator_error";
  static const int GEOLOCATION_STATUS_ACCEPTED = 0;
  static const int GEOLOCATION_STATUS_DENIED = 1;
  static const int GEOLOCATION_STATUS_RESTRICTED = 2;
  static const int GEOLOCATION_STATUS_UNKNOWN = 3;

  static Future<bool> _isServiceEnabled() async {
    return await Geolocator().isLocationServiceEnabled();
  }

  static Future<GeolocationStatus> _checkPermissionStatus() async {
    return await Geolocator().checkGeolocationPermissionStatus();
  }

  static Future<int> _getPermissionStatusAsNumber() async {
    GeolocationStatus status = await _checkPermissionStatus();
    return _fromGeolocationStatus(status);
  }

  static Future<LocationResponse> findCurrentLocation() async {
    LocationResponse response = LocationResponse.createInstance();
    var isEnabled = await _isServiceEnabled();
      if (!isEnabled) {
        response.error = "Location Service Not Enabled";
        return response;
      }
      var statusNumber = await _getPermissionStatusAsNumber();
      if (statusNumber == null) {
        response.error = "Permission status number is null";
        return response;}

      var position = await Geolocator().getCurrentPosition();
      if (position == null) {
        response.error = "Could not get current location";
        return response;
      }
      response.position = position;
      return response;
  }

  static int _fromGeolocationStatus(GeolocationStatus status) {
    switch (status) {
      case GeolocationStatus.denied:
        return GEOLOCATION_STATUS_DENIED;
      case GeolocationStatus.granted:
        return GEOLOCATION_STATUS_ACCEPTED;
      case GeolocationStatus.restricted:
        return GEOLOCATION_STATUS_RESTRICTED;
      default:
        return GEOLOCATION_STATUS_UNKNOWN;
    }
  }

}

class LocationResponse {
  Position position;
  List<Placemark> placeMarkList;
  String namedPosition;
  String error;

  LocationResponse(this.error);

  LocationResponse.createInstance();
}
