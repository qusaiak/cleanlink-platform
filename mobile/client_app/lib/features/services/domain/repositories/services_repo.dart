import '../entities/service_entity.dart';

abstract class ServicesRepo {
  Future<List<ServiceEntity>> getServices();
  Future<ServiceEntity> getServiceDetails(int id);
}