import 'package:equatable/equatable.dart';

import '../../../companies/domain/entities/company_entity.dart';
import '../../../companies/domain/entities/manager_entity.dart';
import 'manager_entity.dart';
import 'region_company_entity.dart';

class RegionDetailsEntity extends Equatable {
  final int id;
  final String name;
  final String? image;
  final ManagerEntity? manager;
  final List<CompanyEntity> companies;

  const RegionDetailsEntity({
    required this.id,
    required this.name,
    required this.image,
    this.manager,
    this.companies = const [],
  });

  int get totalCompanies => companies.length;

  int get openCompanies => companies.where((c) => c.isOpen).length;

  @override
  List<Object?> get props => [id, name, manager, companies];
}
