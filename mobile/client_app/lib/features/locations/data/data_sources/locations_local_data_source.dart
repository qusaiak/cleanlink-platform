import '../../../../core/storage/shared_storage.dart';
import '../../../../core/storage/storage_data.dart';
import '../models/client_location_model.dart';

abstract class LocationsLocalDataSource {
  Future<List<ClientLocationModel>> getLocations();
  Future<void> saveLocations(List<ClientLocationModel> locations);
  Future<void> clearLocations();
}

class SharedStorageLocationsLocalDataSource
    implements LocationsLocalDataSource {
  const SharedStorageLocationsLocalDataSource();

  @override
  Future<List<ClientLocationModel>> getLocations() async {
    final items = await SharedStorage.getList(StorageData.clientLocations);
    final result = <ClientLocationModel>[];
    for (final item in items) {
      if (item is! Map) continue;
      try {
        result.add(
          ClientLocationModel.fromCacheJson(Map<String, dynamic>.from(item)),
        );
      } on FormatException {
        // Ignore malformed legacy cache entries; the backend refresh replaces it.
      }
    }
    return result;
  }

  @override
  Future<void> saveLocations(List<ClientLocationModel> locations) =>
      SharedStorage.setList(
        StorageData.clientLocations,
        locations.map((location) => location.toJson()).toList(growable: false),
      );

  @override
  Future<void> clearLocations() =>
      SharedStorage.delete(StorageData.clientLocations);
}
