import '../entities/search_entity.dart';
import '../repositories/search_repo.dart';

class SearchUseCase {
  final SearchRepo repo;

  SearchUseCase(this.repo);

  Future<SearchEntity> call(
    String query,
    int? regionId,
    String? priceRange,
    double? rate,
  ) {
    return repo.search(
      query: query,
      regionId: regionId,
      priceRange: priceRange,
      rate: rate,
    );
  }
}
