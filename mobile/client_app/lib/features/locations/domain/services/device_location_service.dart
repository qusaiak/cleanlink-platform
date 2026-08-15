import 'package:geolocator/geolocator.dart';

enum LocationAccessFailure {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class LocationAccessException implements Exception {
  const LocationAccessException(this.failure);

  final LocationAccessFailure failure;
}

abstract class DeviceLocationService {
  Future<Position> getCurrentPosition();

  Future<bool> openApplicationSettings();

  Future<bool> openDeviceLocationSettings();
}

class GeolocatorDeviceLocationService implements DeviceLocationService {
  const GeolocatorDeviceLocationService();

  @override
  Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationAccessException(
        LocationAccessFailure.serviceDisabled,
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationAccessException(
        LocationAccessFailure.permissionDenied,
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationAccessException(
        LocationAccessFailure.permissionDeniedForever,
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Future<bool> openApplicationSettings() => Geolocator.openAppSettings();

  @override
  Future<bool> openDeviceLocationSettings() =>
      Geolocator.openLocationSettings();
}
