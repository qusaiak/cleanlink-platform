import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/attribute_entity.dart';

part 'attribute_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttributeModel {
  final int? id;

  final String? name;

  final String? type;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  @JsonKey(fromJson: _doubleFromJson)
  final double price;

  @JsonKey(fromJson: _intFromJson)
  final int duration;

  const AttributeModel({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.price = 0,
    this.duration = 0,
  });

  factory AttributeModel.fromJson(Map<String, dynamic> json) =>
      _$AttributeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeModelToJson(this);

  AttributeEntity toEntity() {
    return AttributeEntity(
      id: id ?? 0,

      name: name ?? "",

      type: type ?? "",

      createdAt: createdAt ?? DateTime.now(),

      updatedAt: updatedAt ?? DateTime.now(),

      price: price,
      duration: duration,
    );
  }
}

double _doubleFromJson(Object? value) => value is num
    ? value.toDouble()
    : double.tryParse(value?.toString() ?? '') ?? 0;

int _intFromJson(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
