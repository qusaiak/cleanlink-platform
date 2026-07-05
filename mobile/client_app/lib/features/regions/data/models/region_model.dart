import 'package:json_annotation/json_annotation.dart';

import '../../../companies/data/models/manager_model.dart';
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

  RegionModel copyWith({
    int? id,
    String? name,
    String? image,
    int? managerId,
    ManagerModel? manager,
  }) {
    return RegionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      managerId: managerId ?? this.managerId,
      manager: manager ?? this.manager,
    );
  }

  RegionEntity toEntity() => RegionEntity(
    id: id ?? 0,
    name: name ?? "",
    image: image ?? "",
    managerId: managerId ?? 0,
    manager: manager?.toEntity(),
  );
}
