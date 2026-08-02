import '../entities/region_entity.dart';
import '../entities/region_details_entity.dart';
import '../../../../core/pagination/paginated_result.dart';

abstract class RegionsRepo {
  Future<PaginatedResult<RegionEntity>> getRegions({
    required int page,
    required int perPage,
  });

  Future<List<RegionEntity>> getRegionNames();

  Future<RegionDetailsEntity> getRegion(int id);
}
