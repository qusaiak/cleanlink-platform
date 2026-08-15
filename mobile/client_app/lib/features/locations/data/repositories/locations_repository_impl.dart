import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/utils/map_address_normalizer.dart';
import '../../domain/entities/client_location_entity.dart';
import '../../domain/repositories/locations_repository.dart';
import '../data_sources/locations_api_service.dart';
import '../data_sources/locations_local_data_source.dart';
import '../models/location_request_model.dart';
import '../models/client_location_model.dart';

List<ClientLocationModel> mergeRemoteLocationsWithLocalNames({
  required List<ClientLocationModel> remote,
  required List<ClientLocationModel> cached,
}) {
  final cachedNames = {for (final item in cached) item.id: item.localName};
  return [
    for (final item in remote)
      item.copyWith(
        address: normalizeGoogleMapAddress(item.address),
        localName: cachedNames[item.id] ?? '',
      ),
  ];
}

class LocationsRepositoryImpl implements LocationsRepository {
  const LocationsRepositoryImpl(this.api, this.local);

  final LocationsApiService api;
  final LocationsLocalDataSource local;

  @override
  Future<List<ClientLocationEntity>> getCachedLocations() async =>
      (await local.getLocations())
          .map((location) => location.toEntity())
          .toList(growable: false);

  @override
  Future<List<ClientLocationEntity>> refreshLocations() async {
    try {
      final response = await api.getLocations();
      _ensureSuccess(
        response.response.statusCode,
        response.data.status,
        response.data.message,
      );
      final merged = mergeRemoteLocationsWithLocalNames(
        remote: response.data.data,
        cached: await local.getLocations(),
      );
      await local.saveLocations(merged);
      return merged
          .map((location) => location.toEntity())
          .toList(growable: false);
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<ClientLocationEntity> addLocation({
    required String localName,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await api.addLocation(
        LocationRequestModel(
          address: normalizeGoogleMapAddress(address),
          latitude: latitude,
          longitude: longitude,
        ),
      );
      _ensureSuccess(
        response.response.statusCode,
        response.data.status,
        response.data.message,
      );
      final remote = response.data.data;
      if (remote == null) {
        throw ServerFailure(response.data.message, '${response.data.status}');
      }
      final created = remote.copyWith(
        address: normalizeGoogleMapAddress(
          remote.address.isEmpty ? address : remote.address,
        ),
        localName: localName.trim(),
      );
      final models = await local.getLocations();
      await local.saveLocations([...models, created]);
      return created.toEntity();
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<ClientLocationEntity> updateLocation({
    required int id,
    required String localName,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await api.updateLocation(
        id,
        LocationRequestModel(
          address: normalizeGoogleMapAddress(address),
          latitude: latitude,
          longitude: longitude,
        ),
      );
      _ensureSuccess(
        response.response.statusCode,
        response.data.status,
        response.data.message,
      );
      final remote = response.data.data;
      if (remote == null) {
        throw ServerFailure(response.data.message, '${response.data.status}');
      }
      final updated = remote.copyWith(
        address: normalizeGoogleMapAddress(
          remote.address.isEmpty ? address : remote.address,
        ),
        localName: localName.trim(),
      );
      final models = await local.getLocations();
      await local.saveLocations([
        for (final model in models)
          if (model.id == id) updated else model,
      ]);
      return updated.toEntity();
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<void> deleteLocation(int id) async {
    try {
      final response = await api.deleteLocation(id);
      _ensureSuccess(
        response.response.statusCode,
        response.data.status,
        response.data.message,
      );
      final models = await local.getLocations();
      await local.saveLocations([
        for (final model in models)
          if (model.id != id) model,
      ]);
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<void> clearCache() => local.clearLocations();

  void _ensureSuccess(int? httpStatus, int status, String message) {
    final effectiveStatus = status == 0 ? httpStatus ?? 0 : status;
    if ((httpStatus ?? 0) < 200 ||
        (httpStatus ?? 0) >= 300 ||
        effectiveStatus < 200 ||
        effectiveStatus >= 300) {
      throw ServerFailure(message, '$effectiveStatus');
    }
  }
}
