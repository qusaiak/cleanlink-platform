import '../entities/region_entity.dart';
import '../entities/region_details_entity.dart';

abstract class RegionsRepo {
  Future<List<RegionEntity>> getRegions();

  Future<List<RegionEntity>> getRegionNames();

  Future<RegionDetailsEntity> getRegion(int id);
}
