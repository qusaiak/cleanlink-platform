import '../entities/service_entity.dart';
import '../repositories/services_repo.dart';

class GetServiceDetailsUseCase {
  final ServicesRepo repo;

  GetServiceDetailsUseCase(this.repo);

  Future<ServiceEntity> call(int id) {
    return repo.getServiceDetails(id);
  }
}
