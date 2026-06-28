import 'manager_entity.dart';

class RegionEntity {
  final int id;

  final String nameAr;

  final String nameEn;

  final int managerId;

  final ManagerEntity? manager;

  const RegionEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.managerId,
    this.manager,
  });
}