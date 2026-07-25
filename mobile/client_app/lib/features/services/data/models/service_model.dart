import 'package:client_app/features/companies/data/models/review_model.dart';
import 'package:client_app/features/companies/domain/entities/company_entity.dart';
import 'package:client_app/features/services/data/models/package_model.dart';
import 'package:client_app/features/services/data/models/service_gallery_image_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../companies/domain/entities/manager_entity.dart';
import '../../../companies/domain/entities/region_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../../companies/data/models/company_model.dart';
import 'attribute_model.dart';

part 'service_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ServiceModel {
  final int? id;

  final int? companyId;

  final int? categoryId;

  final String? name;

  final String? description;

  final double? rating;

  final int? minDuration;

  final int? maxDuration;

  final int? price;

  final String? image;

  final int? discount;

  final bool? isFavorite;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final CompanyModel? company;

  final List<PackageModel>? packages;

  final List<AttributeModel>? attributes;

  final List<ReviewModel>? reviews;

  final List<ServiceGalleryImageModel>? images;

  const ServiceModel({
    required this.id,
    required this.companyId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.rating,
    required this.minDuration,
    required this.maxDuration,
    required this.price,
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

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  ServiceEntity toEntity() => ServiceEntity(
    id: id ?? 0,
    companyId: companyId ?? 0,
    categoryId: categoryId ?? 0,
    name: name ?? "",
    description: description ?? "",
    rating: rating ?? 0.0,
    minDuration: minDuration ?? 0,
    maxDuration: maxDuration ?? 0,
    price: price ?? 0,
    image: image ?? "",
    discount: discount ?? 0,
    isFavorite: isFavorite ?? false,
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
    company:
        company?.toEntity() ??
        CompanyEntity(
          id: 0,
          managerId: 0,
          regionId: 0,
          name: "",
          description: "",
          image: "",
          location: "",
          rating: 0,
          isFavorite: false,
          manager: ManagerEntity(id: 0, fullname: '', email: '', role: ''),
          region: RegionEntity(
            id: 0,
            name: '',
            image: '',
            managerId: 0,
            manager: ManagerEntity(id: 0, fullname: '', email: '', role: ''),
          ),
          services: [],
          workers: [],
          reviews: [],
          createdAt: createdAt ?? DateTime.now(),
          updatedAt: updatedAt ?? DateTime.now(),
        ),

    packages: packages?.map((e) => e.toEntity()).toList() ?? [],

    attributes: attributes?.map((e) => e.toEntity()).toList() ?? [],

    reviews: reviews?.map((e) => e.toEntity()).toList() ?? [],

    images: images?.map((e) => e.toEntity()).toList() ?? [],
  );
}
