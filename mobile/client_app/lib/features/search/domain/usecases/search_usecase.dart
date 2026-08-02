import '../entities/search_entity.dart';
import '../repositories/search_repo.dart';

class SearchUseCase {
  final SearchRepo repo;

  SearchUseCase(this.repo);

  Future<SearchEntity> call({
    required String query,
    int? regionId,
    double? minimumPrice,
    double? maximumPrice,
    double? rating,
  }) {
    return repo.search(
      query: query,
      regionId: regionId,
      minimumPrice: minimumPrice,
      maximumPrice: maximumPrice,
      rating: rating,
    );
  }
}
