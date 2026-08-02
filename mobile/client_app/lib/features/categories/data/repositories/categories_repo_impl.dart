import 'package:dio/dio.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/categories_repo.dart';
import '../data_sources/categories_api_service.dart';

class CategoriesRepoImpl implements CategoriesRepo {
  final CategoriesApiService api;

  CategoriesRepoImpl(this.api);

  @override
  Future<PaginatedResult<CategoryEntity>> getCategories({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await api.getCategories(page: page, perPage: perPage);
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<CategoryEntity> getCategory(int id) async {
    try {
      final response = await api.getCategory(id);
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }
}
