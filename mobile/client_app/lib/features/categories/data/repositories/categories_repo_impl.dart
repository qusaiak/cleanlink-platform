import 'package:client_app/features/categories/domain/entities/category_entity.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/repositories/categories_repo.dart';
import '../data_sources/categories_api_service.dart';

class CategoriesRepoImpl implements CategoriesRepo {
  final CategoriesApiService api;

  CategoriesRepoImpl(this.api);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await api.getCategories();
      print("RAW RESPONSE");
      print(response.data.data);
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }
}
