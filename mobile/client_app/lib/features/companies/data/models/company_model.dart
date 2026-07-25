import 'package:client_app/features/companies/data/models/review_model.dart';
import 'package:client_app/features/companies/data/models/worker_model.dart';
import 'package:client_app/features/services/data/models/service_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'company_work_time_model.dart';
import 'manager_model.dart';
import 'region_model.dart';
import '../../domain/entities/manager_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/entities/company_entity.dart';

part 'company_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CompanyModel {
  @JsonKey(fromJson: _intFromJson)
  final int? id;
  @JsonKey(fromJson: _intFromJson)
  final int? managerId;
  @JsonKey(fromJson: _intFromJson)
  final int? regionId;

  final String? name;

  final String? description;

  final String? image;

  final String? location;

  @JsonKey(fromJson: _doubleFromJson)
  final double? rating;

  @JsonKey(fromJson: _boolFromJson)
  final bool? isFavorite;

  final ManagerModel? manager;
  final RegionModel? region;
  final List<ServiceModel>? services;
  final List<WorkerModel>? workers;
  final List<ReviewModel>? reviews;

  @JsonKey(name: 'workTimes', fromJson: _workTimesFromJson)
  final List<CompanyWorkTimeModel> workTimes;

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
    this.isFavorite,
    this.manager,
    this.region,
    this.services,
    this.workers,
    this.reviews,
    this.workTimes = const [],
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
    isFavorite: isFavorite ?? false,
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
    workTimes: workTimes.map((e) => e.toEntity()).toList(growable: false),
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
  );
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int? _intFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

bool? _boolFromJson(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value == 1;
  final normalized = value.toString().trim().toLowerCase();
  if (normalized == '1' || normalized == 'true') return true;
  if (normalized == '0' || normalized == 'false') return false;
  return null;
}

List<CompanyWorkTimeModel> _workTimesFromJson(dynamic value) {
  if (value is! List) return const [];
  final workTimes = <CompanyWorkTimeModel>[];
  for (final item in value) {
    if (item is! Map) continue;
    try {
      final workTime = CompanyWorkTimeModel.tryFromJson(
        Map<String, dynamic>.from(item),
      );
      if (workTime != null) workTimes.add(workTime);
    } catch (_) {
      // A malformed item must not invalidate the rest of the company payload.
    }
  }
  return List.unmodifiable(workTimes);
}
