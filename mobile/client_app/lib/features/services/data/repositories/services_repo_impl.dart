import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/repositories/services_repo.dart';
import '../data_sources/services_api_service.dart';

class ServicesRepoImpl implements ServicesRepo {
  final ServicesApiService api;

  ServicesRepoImpl(this.api);

  @override
  Future<List<ServiceEntity>> getServices() async {
    try {
      final response = await api.getServices();
      print("RAW RESPONSE");
      print(response.data.data);
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
