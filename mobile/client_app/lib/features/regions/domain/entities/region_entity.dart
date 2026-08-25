import 'package:equatable/equatable.dart';

import '../../../companies/domain/entities/manager_entity.dart';

class RegionEntity extends Equatable {
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

  @override
  List<Object?> get props => [id, name, image, managerId, manager];
}
