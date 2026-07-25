import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/package_entity.dart';

part 'package_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PackageModel {
  final int? id;

  final int? serviceId;

  final String? name;

  final int? duration;

  final int? price;

  final int? priceAfterDiscount;

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

      details: details ?? [],

      createdAt: createdAt ?? DateTime.now(),

      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
