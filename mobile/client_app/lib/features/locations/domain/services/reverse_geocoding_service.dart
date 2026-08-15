import 'package:geocoding/geocoding.dart';

abstract class ReverseGeocodingService {
  Future<String?> resolveAddress({
    required double latitude,
    required double longitude,
  });
}

class DeviceReverseGeocodingService implements ReverseGeocodingService {
  const DeviceReverseGeocodingService();

  @override
  Future<String?> resolveAddress({
    required double latitude,
    required double longitude,
  }) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) return null;

    final placemark = placemarks.first;
    final parts = <String?>[
      placemark.street,
      placemark.subLocality,
      placemark.locality,
      placemark.administrativeArea,
      placemark.country,
    ];
    final uniqueParts = <String>[];
    for (final part in parts) {
      final value = part?.trim();
      if (value != null && value.isNotEmpty && !uniqueParts.contains(value)) {
        uniqueParts.add(value);
      }
    }
    return uniqueParts.isEmpty ? null : uniqueParts.join(', ');
  }
}
