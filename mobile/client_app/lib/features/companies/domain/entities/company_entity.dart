import 'package:client_app/features/services/domain/entities/service_entity.dart';

import 'manager_entity.dart';
import 'region_entity.dart';

class CompanyEntity {
  final int id;

  final int managerId;

  final int regionId;

  final String nameAr;
  final String nameEn;

  final String descriptionAr;
  final String descriptionEn;

  final String image;

  final String locationAr;
  final String locationEn;

  final String rating;

  final int isOpen;

  final String startHour;
  final String closeHour;

  final ManagerEntity manager;

  final RegionEntity region;

  final List<ServiceEntity> services;

  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyEntity({
    required this.id,
    required this.managerId,
    required this.regionId,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.image,
    required this.locationAr,
    required this.locationEn,
    required this.rating,
    required this.isOpen,
    required this.startHour,
    required this.closeHour,
    required this.manager,
    required this.region,
    required this.services,
    required this.createdAt,
    required this.updatedAt,
  });
}
