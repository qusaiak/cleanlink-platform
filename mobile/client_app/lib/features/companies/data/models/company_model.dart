import 'package:client_app/features/companies/data/models/review_model.dart';
import 'package:client_app/features/companies/data/models/worker_model.dart';
import 'package:client_app/features/companies/domain/entities/worker_entity.dart';
import 'package:client_app/features/services/data/models/service_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manager_model.dart';
import 'region_model.dart';
import '../../domain/entities/manager_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/entities/company_entity.dart';

part 'company_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CompanyModel {
  final int? id;
  final int? managerId;
  final int? regionId;

  final String? name;

  final String? description;

  final String? image;

  final String? location;

  final int? rating;

  final bool? isOpen;
  final bool? isFavorite;

  final String? startHour;
  final String? closeHour;

  final ManagerModel? manager;
  final RegionModel? region;
  final List<ServiceModel>? services;
  final List<WorkerModel>? workers;
  final List<ReviewModel>? reviews;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CompanyModel({
    this.id,
    this.managerId,
    this.regionId,
    this.name,
    this.description,
    this.image,
    this.location,
    this.rating,
    this.isOpen,
    this.isFavorite,
    this.startHour,
    this.closeHour,
    this.manager,
    this.region,
    this.services,
    this.workers,
    this.reviews,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  CompanyEntity toEntity() => CompanyEntity(
    id: id ?? 0,
    managerId: managerId ?? 0,
    regionId: regionId ?? 0,
    name: name ?? "",
    description: description ?? "",
    image: image ?? "",
    location: location ?? "",
    rating: rating ?? 0,
    isOpen: isOpen ?? true,
    isFavorite: isFavorite ?? false,
    startHour: startHour ?? "",
    closeHour: closeHour ?? "",
    manager:
        manager?.toEntity() ??
        ManagerEntity(id: 0, fullname: '', email: '', role: ''),
    region:
        region?.toEntity() ??
        RegionEntity(
          id: 0,
          name: '',
          image: '',
          managerId: 0,
          manager:
              manager?.toEntity() ??
              ManagerEntity(id: 0, fullname: '', email: '', role: ''),
        ),
    services: services?.map((e) => e.toEntity()).toList() ?? [],
    workers: workers?.map((e) => e.toEntity()).toList() ?? [],
    reviews: reviews?.map((e) => e.toEntity()).toList() ?? [],
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
