import '../../../services/domain/entities/service_entity.dart';
import '../../../companies/domain/entities/company_entity.dart';

class FavoriteEntity {
  final List<ServiceEntity> services;
  final List<CompanyEntity> companies;

  const FavoriteEntity({
    required this.services,
    required this.companies,
  });
}
