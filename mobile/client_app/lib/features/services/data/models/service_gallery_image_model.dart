import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/service_gallery_image_entity.dart';

part 'service_gallery_image_model.g.dart';

@JsonSerializable()
class ServiceGalleryImageModel {
  final int id;

  @JsonKey(name: 'service_id')
  final int serviceId;

  @JsonKey(name: 'image_before')
  final String imageBefore;

  @JsonKey(name: 'image_after')
  final String imageAfter;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const ServiceGalleryImageModel({
    required this.id,
    required this.serviceId,
    required this.imageBefore,
    required this.imageAfter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceGalleryImageModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceGalleryImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceGalleryImageModelToJson(this);

  ServiceGalleryImageEntity toEntity() {
    return ServiceGalleryImageEntity(
      id: id,
      serviceId: serviceId,
      imageBefore: imageBefore,
      imageAfter: imageAfter,
    );
  }
}
