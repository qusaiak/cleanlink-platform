import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/package_entity.dart';

part 'package_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PackageModel {
  final int? id;

  final int? serviceId;

  final String? name;

  final int? duration;

  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? price;

  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? priceAfterDiscount;

  final int? minimumWorkers;

  final bool? isOpenPackage;

  final List<String>? details;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  const PackageModel({
    this.id,
    this.serviceId,
    this.name,
    this.duration,
    this.price,
    this.priceAfterDiscount,
    this.minimumWorkers,
    this.isOpenPackage,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) =>
      _$PackageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PackageModelToJson(this);

  PackageEntity toEntity() {
    return PackageEntity(
      id: id ?? 0,
      serviceId: serviceId ?? 0,

      name: name ?? "",

      duration: duration ?? 0,

      price: price ?? 0,

      priceAfterDiscount: priceAfterDiscount ?? 0,

      minimumWorkers: minimumWorkers ?? 1,

      isOpenPackage: isOpenPackage ?? false,

      details: details ?? [],

      createdAt: createdAt ?? DateTime.now(),

      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

double? _nullableDoubleFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
