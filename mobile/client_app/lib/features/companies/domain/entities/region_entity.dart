import 'manager_entity.dart';

class RegionEntity {
  final int id;

  final String name;

  final String image;

  final int managerId;

  final ManagerEntity? manager;

  const RegionEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.managerId,
    this.manager,
  });
}
