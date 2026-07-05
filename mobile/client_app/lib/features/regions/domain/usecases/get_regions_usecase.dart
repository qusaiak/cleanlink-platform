import '../entities/region_entity.dart';
import '../repositories/regions_repo.dart';

class GetRegionsUseCase {
  final RegionsRepo repo;

  GetRegionsUseCase(this.repo);

  Future<List<RegionEntity>> call() {
    return repo.getRegions();
  }
}
