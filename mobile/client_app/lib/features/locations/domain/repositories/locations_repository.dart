import '../entities/client_location_entity.dart';

abstract class LocationsRepository {
  Future<List<ClientLocationEntity>> getCachedLocations();
  Future<List<ClientLocationEntity>> refreshLocations();
  Future<ClientLocationEntity> addLocation({
    required String localName,
    required String address,
    required double latitude,
    required double longitude,
  });
  Future<ClientLocationEntity> updateLocation({
    required int id,
    required String localName,
    required String address,
    required double latitude,
    required double longitude,
  });
  Future<void> deleteLocation(int id);
  Future<void> clearCache();
}
