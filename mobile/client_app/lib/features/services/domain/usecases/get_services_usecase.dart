import '../entities/service_entity.dart';
import '../repositories/services_repo.dart';
import '../../../../core/pagination/paginated_result.dart';

class GetServicesUseCase {
  final ServicesRepo repo;

  GetServicesUseCase(this.repo);

  Future<PaginatedResult<ServiceEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repo.getServices(page: page, perPage: perPage);
  }
}
