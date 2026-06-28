import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/pivot_entity.dart';

part 'pivot_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PivotModel {
  final int? serviceId;

  final int? attributeId;

  final String? price;

  final int? duration;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  const PivotModel({
    this.serviceId,
    this.attributeId,
    this.price,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory PivotModel.fromJson(Map<String, dynamic> json) =>
      _$PivotModelFromJson(json);

  Map<String, dynamic> toJson() => _$PivotModelToJson(this);

  PivotEntity toEntity() {
    return PivotEntity(
      serviceId: serviceId ?? 0,
      attributeId: attributeId ?? 0,
      price: price ?? "0",
      duration: duration ?? 0,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
