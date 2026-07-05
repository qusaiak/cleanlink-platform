import '../entities/region_details_entity.dart';
import '../repositories/regions_repo.dart';

class GetRegionUseCase {
  final RegionsRepo repo;

  GetRegionUseCase(this.repo);

  Future<RegionDetailsEntity> call(int id) {
    return repo.getRegion(id);
  }
}
