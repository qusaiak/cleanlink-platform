import '../entities/service_entity.dart';
import '../repositories/services_repo.dart';

class GetServicesUseCase {
  final ServicesRepo repo;

  GetServicesUseCase(this.repo);

  Future<List<ServiceEntity>> call() {
    return repo.getServices();
  }
}
