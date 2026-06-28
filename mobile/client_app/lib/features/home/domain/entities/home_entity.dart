import '../../../services/domain/entities/service_entity.dart';
import '../../../companies/domain/entities/company_entity.dart';
import '../../../categories/domain/entities/category_entity.dart';

class HomeEntity {

  final List<ServiceEntity> offers;

  final List<ServiceEntity> services;

  final List<CategoryEntity> categories;

  final List<CompanyEntity> companies;

  const HomeEntity({
    required this.offers,
    required this.services,
    required this.categories,
    required this.companies,
  });

}
