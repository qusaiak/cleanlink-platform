import '../entities/client_location_entity.dart';
import '../repositories/locations_repository.dart';

class GetCachedLocationsUseCase {
  const GetCachedLocationsUseCase(this.repository);
  final LocationsRepository repository;
  Future<List<ClientLocationEntity>> call() => repository.getCachedLocations();
}

class RefreshLocationsUseCase {
  const RefreshLocationsUseCase(this.repository);
  final LocationsRepository repository;
  Future<List<ClientLocationEntity>> call() => repository.refreshLocations();
}

class AddLocationUseCase {
  const AddLocationUseCase(this.repository);
  final LocationsRepository repository;
  Future<ClientLocationEntity> call({
    required String localName,
    required String address,
    required double latitude,
    required double longitude,
  }) => repository.addLocation(
    localName: localName,
    address: address,
    latitude: latitude,
    longitude: longitude,
  );
}

class UpdateLocationUseCase {
  const UpdateLocationUseCase(this.repository);
  final LocationsRepository repository;
  Future<ClientLocationEntity> call({
    required int id,
    required String localName,
    required String address,
    required double latitude,
    required double longitude,
  }) => repository.updateLocation(
    id: id,
    localName: localName,
    address: address,
    latitude: latitude,
    longitude: longitude,
  );
}

class DeleteLocationUseCase {
  const DeleteLocationUseCase(this.repository);
  final LocationsRepository repository;
  Future<void> call(int id) => repository.deleteLocation(id);
}
