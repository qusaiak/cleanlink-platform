import 'package:client_app/features/companies/domain/entities/review_entity.dart';
import 'package:client_app/features/services/domain/entities/package_entity.dart';
import 'package:client_app/features/services/domain/entities/service_gallery_image_entity.dart';

import '../../../companies/domain/entities/company_entity.dart';
import 'attribute_entity.dart';

class ServiceEntity {
  final int id;
  final int companyId;
  final int categoryId;

  final String name;

  final String description;

  final double rating;

  final int minDuration;
  final int maxDuration;

  final double? minPrice;
  final double? maxPrice;

  final String image;

  final double discount;

  final bool isFavorite;

  final DateTime createdAt;
  final DateTime updatedAt;

  final CompanyEntity? company;

  final List<PackageEntity>? packages;

  final List<AttributeEntity>? attributes;

  final List<ReviewEntity>? reviews;

  final List<ServiceGalleryImageEntity>? images;

  const ServiceEntity({
    required this.id,
    required this.companyId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.rating,
    required this.minDuration,
    required this.maxDuration,
    required this.minPrice,
    required this.maxPrice,
    required this.image,
    required this.discount,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    this.company,
    this.packages,
    this.attributes,
    this.reviews,
    this.images,
  });

  ServiceEntity copyWith({
    int? id,
    int? companyId,
    int? categoryId,
    String? name,
    String? description,
    double? rating,
    int? minDuration,
    int? maxDuration,
    double? minPrice,
    double? maxPrice,
    String? image,
    double? discount,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    CompanyEntity? company,
    List<PackageEntity>? packages,
    List<AttributeEntity>? attributes,
    List<ReviewEntity>? reviews,
    List<ServiceGalleryImageEntity>? images,
  }) {
    return ServiceEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      image: image ?? this.image,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      company: company ?? this.company,
      packages: packages ?? this.packages,
      attributes: attributes ?? this.attributes,
      reviews: reviews ?? this.reviews,
      images: images ?? this.images,
    );
  }
}
