import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/region_company_entity.dart';

part 'region_company_model.g.dart';

bool _isOpenFromJson(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value == 1;
  if (value is String) {
    return value == '1' || value.toLowerCase() == 'true';
  }
  return false;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RegionCompanyModel {
  final int? id;
  final int? managerId;
  final int? regionId;
  final String? name;
  final String? description;
  final String? image;
  final String? location;
  final double? rating;

  @JsonKey(name: 'is_open', fromJson: _isOpenFromJson)
  final bool isOpen;

  final String? startHour;
  final String? closeHour;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RegionCompanyModel({
    this.id,
    this.managerId,
    this.regionId,
    this.name,
    this.description,
    this.image,
    this.location,
    this.rating,
    this.isOpen = false,
    this.startHour,
    this.closeHour,
    this.createdAt,
    this.updatedAt,
  });

  factory RegionCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$RegionCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionCompanyModelToJson(this);

  RegionCompanyEntity toEntity() => RegionCompanyEntity(
        id: id ?? 0,
        managerId: managerId ?? 0,
        regionId: regionId ?? 0,
        name: name ?? "",
        description: description ?? "",
        image: image ?? "",
        location: location ?? "",
        rating: rating ?? 0.0,
        isOpen: isOpen,
        startHour: startHour ?? "",
        closeHour: closeHour ?? "",
      );
}
