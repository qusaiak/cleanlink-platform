import '../entities/service_entity.dart';
import '../repositories/services_repo.dart';

class GetOffersUseCase {
  final ServicesRepo repo;

  GetOffersUseCase(this.repo);

  Future<List<ServiceEntity>> call() {
    return repo.getOffers();
  }
}
