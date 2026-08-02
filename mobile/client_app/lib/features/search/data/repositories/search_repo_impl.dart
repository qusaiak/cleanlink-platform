import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/repositories/search_repo.dart';
import '../data_sources/search_api_service.dart';
import '../models/search_request_model.dart';

class SearchRepoImpl implements SearchRepo {
  final SearchApiService api;

  SearchRepoImpl(this.api);

  @override
  Future<SearchEntity> search({
    required String query,
    int? regionId,
    double? minimumPrice,
    double? maximumPrice,
    double? rating,
  }) async {
    try {
      final request = SearchRequestModel(
        query: query,
        regionId: regionId,
        minimumPrice: minimumPrice,
        maximumPrice: maximumPrice,
        rating: rating,
      );
      final response = await api.search(request.toJson());
      final data = response.data.data;
      if (data == null) {
        throw const ServerFailure('Invalid search response structure', '');
      }
      return data.toEntity();
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }
}
