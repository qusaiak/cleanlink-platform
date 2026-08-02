import '../entities/service_entity.dart';
import '../repositories/services_repo.dart';
import '../../../../core/pagination/paginated_result.dart';

class GetOffersUseCase {
  final ServicesRepo repo;

  GetOffersUseCase(this.repo);

  Future<PaginatedResult<ServiceEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repo.getOffers(page: page, perPage: perPage);
  }
}
