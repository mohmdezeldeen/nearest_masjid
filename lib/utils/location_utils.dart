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

  static Future<Position> _currentPosition() async {
    return await Geolocator().getCurrentPosition();
  }

  static Future<List<Placemark>> _convertCoordinatesToPlaceMarks(
      Position position) async {
    return await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
  }

  static Future<String> _getCurrentLocationName() async {
    Position position = await _currentPosition();
    return _getPositionLocationName(position);
  }

  static Future<String> _getPositionLocationName(Position position) async {
    List<Placemark> placeMarks =
        await _convertCoordinatesToPlaceMarks(position);
    return _convertPlaceMarksToLocationName(placeMarks);
  }

  static String _convertPlaceMarksToLocationName(List<Placemark> placeMarks) {
    String placeMarkName = "";
    var placeMark = placeMarks.first;
    placeMarkName =
        '${placeMark.name ?? ''} ${placeMark.subLocality ?? ''},${placeMark.locality ?? ''}, ${placeMark.subAdministrativeArea ?? ''},${placeMark.administrativeArea ?? ''},${placeMark.country ?? ''}';
    return placeMarkName;
  }

  static Future<LocationResponse> findCurrentLocationName() async {
    LocationResponse response = LocationResponse.createInstance();
    return await _isServiceEnabled().then((isEnabled) async {
      if (!isEnabled) {
        response.error = "Location Service Not Enabled";
        return null;
      }
      return await _getPermissionStatusAsNumber();
    }).then((statusNumber) async {
      if (statusNumber == null) return null;
      return await Geolocator().getCurrentPosition();
    }).then((pos) async {
      if (pos == null) return null;
      response.position = pos;
      return await _convertCoordinatesToPlaceMarks(response.position);
    }).then((placeMarks) async {
      if (placeMarks == null) return response;
      response.placeMarkList = placeMarks;
      response.namedPosition =
          await _convertPlaceMarksToLocationName(placeMarks);
      return response;
    });
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

  static String _toGeolcationStatus(int statusNumber) {
    switch (statusNumber) {
      case GEOLOCATION_STATUS_DENIED:
        return GeolocationStatus.denied.toString();
      case GEOLOCATION_STATUS_ACCEPTED:
        return GeolocationStatus.granted.toString();
      case GEOLOCATION_STATUS_RESTRICTED:
        return GeolocationStatus.restricted.toString();
      default:
        return GeolocationStatus.unknown.toString();
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
