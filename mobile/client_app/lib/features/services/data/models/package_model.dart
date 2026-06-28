import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/package_entity.dart';

part 'package_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PackageModel {
  final int? id;

  final int? serviceId;

  final String? nameAr;

  final String? nameEn;

  final int? duration;

  final String? price;

  final String? priceAfterDiscount;

  final List<String>? detailsAr;

  final List<String>? detailsEn;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  const PackageModel({
    this.id,
    this.serviceId,
    this.nameAr,
    this.nameEn,
    this.duration,
    this.price,
    this.priceAfterDiscount,
    this.detailsAr,
    this.detailsEn,
    this.createdAt,
    this.updatedAt,
  });

  factory PackageModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$PackageModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PackageModelToJson(this);

  PackageEntity toEntity() {
    return PackageEntity(
      id: id ?? 0,
      serviceId: serviceId ?? 0,

      nameAr: nameAr ?? "",
      nameEn: nameEn ?? "",

      duration: duration ?? 0,

      price: price ?? "0",

      priceAfterDiscount:
      priceAfterDiscount ??
          "0",

      detailsAr:
      detailsAr ?? [],

      detailsEn:
      detailsEn ?? [],

      createdAt:
      createdAt ??
          DateTime.now(),

      updatedAt:
      updatedAt ??
          DateTime.now(),
    );
  }
}