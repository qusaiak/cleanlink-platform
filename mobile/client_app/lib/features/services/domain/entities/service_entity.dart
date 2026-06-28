import 'package:client_app/features/services/domain/entities/package_entity.dart';

import '../../../companies/domain/entities/company_entity.dart';
import 'attribute_entity.dart';

class ServiceEntity {
  final int id;
  final int companyId;
  final int categoryId;

  final String nameAr;
  final String nameEn;

  final String descriptionAr;
  final String descriptionEn;

  final String rating;

  final int minDuration;
  final int maxDuration;

  final String price;

  final String image;

  final String discount;

  final DateTime createdAt;
  final DateTime updatedAt;

  final CompanyEntity? company;

  final List<PackageEntity>? packages;

  final List<AttributeEntity>? attributes;

  final List<dynamic>? reviews;

  final List<dynamic>? images;

  const ServiceEntity({
    required this.id,
    required this.companyId,
    required this.categoryId,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.rating,
    required this.minDuration,
    required this.maxDuration,
    required this.price,
    required this.image,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
    this.company,
    this.packages,
    this.attributes,
    this.reviews,
    this.images,
  });
}
