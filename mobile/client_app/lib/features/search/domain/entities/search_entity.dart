import '../../../categories/domain/entities/category_entity.dart';
import '../../../companies/domain/entities/company_entity.dart';
import '../../../regions/domain/entities/region_entity.dart';
import '../../../services/domain/entities/service_entity.dart';

class SearchEntity {

  final List<RegionEntity> regions;

  final List<CategoryEntity> categories;

  final List<CompanyEntity> companies;

  final List<ServiceEntity> services;

  final List<ServiceEntity> offers;

  const SearchEntity({

    required this.regions,

    required this.categories,

    required this.companies,

    required this.services,

    required this.offers,
  });
}