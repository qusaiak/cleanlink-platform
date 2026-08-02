import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../domain/repositories/services_repo.dart';
import '../data_sources/services_api_service.dart';

class ServicesRepoImpl implements ServicesRepo {
  final ServicesApiService api;

  ServicesRepoImpl(this.api);

  @override
  Future<PaginatedResult<ServiceEntity>> getServices({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await api.getServices(page: page, perPage: perPage);
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<PaginatedResult<ServiceEntity>> getOffers({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await api.getOffers(page: page, perPage: perPage);
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<ServiceEntity> getServiceDetails(int id) async {
    try {
      final response = await api.getServiceDetails(id);

      return response.data.data.toEntity();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
