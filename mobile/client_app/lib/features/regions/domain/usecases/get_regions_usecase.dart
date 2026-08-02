import '../entities/region_entity.dart';
import '../repositories/regions_repo.dart';
import '../../../../core/pagination/paginated_result.dart';

class GetRegionsUseCase {
  final RegionsRepo repo;

  GetRegionsUseCase(this.repo);

  Future<PaginatedResult<RegionEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repo.getRegions(page: page, perPage: perPage);
  }
}
