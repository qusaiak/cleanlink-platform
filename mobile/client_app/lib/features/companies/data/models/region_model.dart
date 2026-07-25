import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/region_entity.dart';

import 'manager_model.dart';

part 'region_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegionModel {
  final int? id;

  final String? name;

  final String? image;

  final int? managerId;

  final ManagerModel? manager;

  const RegionModel({
    this.id,
    this.name,
    this.image,
    this.managerId,
    this.manager,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionModelToJson(this);

  RegionEntity toEntity() => RegionEntity(
    id: id ?? 0,
    name: name ?? '',
    image: image ?? '',
    managerId: managerId ?? 0,
    manager: manager?.toEntity(),
  );
}
