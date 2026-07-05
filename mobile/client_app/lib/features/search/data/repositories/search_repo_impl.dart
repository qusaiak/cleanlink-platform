import '../../domain/entities/search_entity.dart';
import '../../domain/repositories/search_repo.dart';
import '../data_sources/search_api_service.dart';

class SearchRepoImpl implements SearchRepo {
  final SearchApiService api;

  SearchRepoImpl(this.api);

  @override
  Future<SearchEntity> search({
    required String query,
    int? regionId,
    String? priceRange,
    double? rate,
  }) async {
    final response = await api.search({
      "query": query,
      "region_id": regionId,
      "price_range": priceRange,
      "rate": rate,
    });

    return response.data.data!.toEntity();
  }
}
