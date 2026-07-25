import 'package:equatable/equatable.dart';
import 'package:client_app/features/companies/domain/entities/review_entity.dart';
import 'package:client_app/features/companies/domain/entities/worker_entity.dart';
import 'package:client_app/features/services/domain/entities/service_entity.dart';

import 'manager_entity.dart';
import 'region_entity.dart';
import 'company_work_time_entity.dart';

class CompanyEntity extends Equatable {
  final int id;

  final int managerId;

  final int regionId;

  final String name;

  final String description;

  final String image;

  final String location;

  final double rating;

  final bool isFavorite;

  final ManagerEntity manager;

  final RegionEntity region;

  final List<ServiceEntity> services;

  final List<WorkerEntity> workers;

  final List<ReviewEntity> reviews;

  final List<CompanyWorkTimeEntity> workTimes;

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
    required this.isFavorite,
    required this.manager,
    required this.region,
    required this.services,
    required this.workers,
    required this.reviews,
    this.workTimes = const [],
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
    double? rating,
    bool? isFavorite,
    ManagerEntity? manager,
    RegionEntity? region,
    List<ServiceEntity>? services,
    List<WorkerEntity>? workers,
    List<ReviewEntity>? reviews,
    List<CompanyWorkTimeEntity>? workTimes,
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
      isFavorite: isFavorite ?? this.isFavorite,
      manager: manager ?? this.manager,
      region: region ?? this.region,
      services: services ?? this.services,
      workers: workers ?? this.workers,
      reviews: reviews ?? this.reviews,
      workTimes: workTimes ?? this.workTimes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    managerId,
    regionId,
    name,
    description,
    image,
    location,
    rating,
    isFavorite,
    manager,
    region,
    services,
    workers,
    reviews,
    workTimes,
    createdAt,
    updatedAt,
  ];
}
