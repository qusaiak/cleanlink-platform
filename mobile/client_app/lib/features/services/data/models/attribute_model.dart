import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/attribute_entity.dart';
import '../../domain/entities/pivot_entity.dart';
import 'pivot_model.dart';

part 'attribute_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttributeModel {
  final int? id;

  final String? nameAr;

  final String? nameEn;

  final String? type;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final PivotModel? pivot;

  const AttributeModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory AttributeModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$AttributeModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttributeModelToJson(this);

  AttributeEntity toEntity() {
    return AttributeEntity(
      id: id ?? 0,

      nameAr:
      nameAr ?? "",

      nameEn:
      nameEn ?? "",

      type:
      type ?? "",

      createdAt:
      createdAt ??
          DateTime.now(),

      updatedAt:
      updatedAt ??
          DateTime.now(),

      pivot:
      pivot?.toEntity() ??
          PivotEntity(
            serviceId: 0,
            attributeId: 0,
            price: "0",
            duration: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
    );
  }
}