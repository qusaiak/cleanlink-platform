import 'package:dio/dio.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/region_details_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/repositories/regions_repo.dart';
import '../data_sources/regions_api_service.dart';

class RegionsRepoImpl implements RegionsRepo {
  final RegionsApiService api;

  RegionsRepoImpl(this.api);

  @override
  Future<List<RegionEntity>> getRegions() async {
    try {
      final response = await api.getRegions();
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<List<RegionEntity>> getRegionNames() async {
    try {
      final response = await api.getRegionNames();
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<RegionDetailsEntity> getRegion(int id) async {
    try {
      final response = await api.getRegion(id);
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }
}
