import '../entities/service_entity.dart';
import '../../../../core/pagination/paginated_result.dart';

abstract class ServicesRepo {
  Future<PaginatedResult<ServiceEntity>> getServices({
    required int page,
    required int perPage,
  });
  Future<PaginatedResult<ServiceEntity>> getOffers({
    required int page,
    required int perPage,
  });
  Future<ServiceEntity> getServiceDetails(int id);
}
