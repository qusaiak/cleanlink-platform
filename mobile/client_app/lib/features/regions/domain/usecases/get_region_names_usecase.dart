import '../entities/region_entity.dart';
import '../repositories/regions_repo.dart';

class GetRegionNamesUseCase {
  final RegionsRepo repo;

  GetRegionNamesUseCase(this.repo);

  Future<List<RegionEntity>> call() {
    return repo.getRegionNames();
  }
}
