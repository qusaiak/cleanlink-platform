import 'package:dio/dio.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repo.dart';
import '../data_sources/home_api_service.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeApiService api;

  HomeRepoImpl(this.api);

  @override
  Future<HomeEntity> getHome() async {
    try {
      final response = await api.getHome();
      return response.data.data!.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }
}
