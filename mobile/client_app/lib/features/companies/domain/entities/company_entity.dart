import 'package:client_app/features/companies/domain/entities/review_entity.dart';
import 'package:client_app/features/companies/domain/entities/worker_entity.dart';
import 'package:client_app/features/services/domain/entities/service_entity.dart';

import 'manager_entity.dart';
import 'region_entity.dart';

class CompanyEntity {
  final int id;

  final int managerId;

  final int regionId;

  final String name;

  final String description;

  final String image;

  final String location;

  final int rating;

  final bool isOpen;

  final bool isFavorite;

  final String startHour;
  final String closeHour;

  final ManagerEntity manager;

  final RegionEntity region;

  final List<ServiceEntity> services;

  final List<WorkerEntity> workers;

  final List<ReviewEntity> reviews;

  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyEntity({
    required this.id,
    required this.managerId,
    required this.regionId,
    required this.name,
    required this.description,
    required this.image,
    required this.location,
    required this.rating,
    required this.isOpen,
    required this.isFavorite,
    required this.startHour,
    required this.closeHour,
    required this.manager,
    required this.region,
    required this.services,
    required this.workers,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  CompanyEntity copyWith({
    int? id,
    int? managerId,
    int? regionId,
    String? name,
    String? description,
    String? image,
    String? location,
    int? rating,
    bool? isOpen,
    bool? isFavorite,
    String? startHour,
    String? closeHour,
    ManagerEntity? manager,
    RegionEntity? region,
    List<ServiceEntity>? services,
    List<WorkerEntity>? workers,
    List<ReviewEntity>? reviews,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      managerId: managerId ?? this.managerId,
      regionId: regionId ?? this.regionId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen,
      isFavorite: isFavorite ?? this.isFavorite,
      startHour: startHour ?? this.startHour,
      closeHour: closeHour ?? this.closeHour,
      manager: manager ?? this.manager,
      region: region ?? this.region,
      services: services ?? this.services,
      workers: workers ?? this.workers,
      reviews: reviews ?? this.reviews,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
