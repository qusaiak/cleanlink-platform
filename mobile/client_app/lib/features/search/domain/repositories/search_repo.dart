import '../entities/search_entity.dart';

abstract class SearchRepo {
  Future<SearchEntity> search({
    required String query,
    int? regionId,
    double? minimumPrice,
    double? maximumPrice,
    double? rating,
  });
}
