import 'package:client_app/features/companies/domain/entities/company_entity.dart';
import 'package:client_app/features/services/data/models/package_model.dart';
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

  final String? nameAr;

  final String? nameEn;

  final String? descriptionAr;

  final String? descriptionEn;

  final String? rating;

  final int? minDuration;

  final int? maxDuration;

  final String? price;

  final String? image;

  final String? discount;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final CompanyModel? company;

  final List<PackageModel>? packages;

  final List<AttributeModel>? attributes;

  final List<dynamic>? reviews;

  final List<dynamic>? images;

  const ServiceModel({
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

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  ServiceEntity toEntity() => ServiceEntity(
    id: id ?? 0,
    companyId: companyId ?? 0,
    categoryId: categoryId ?? 0,
    nameAr: nameAr ?? "",
    nameEn: nameEn ?? "",
    descriptionAr: descriptionAr ?? "",
    descriptionEn: descriptionEn ?? "",
    rating: (rating ?? "0"),
    minDuration: minDuration ?? 0,
    maxDuration: maxDuration ?? 0,
    price: price ?? "0",
    image: image ?? "",
    discount: discount ?? "0",
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
    company:
        company?.toEntity() ??
        CompanyEntity(
          id: 0,
          managerId: 0,
          regionId: 0,
          nameAr: "",
          nameEn: "",
          descriptionAr: "",
          descriptionEn: "",
          image: "",
          locationAr: "",
          locationEn: "",
          rating: "0",
          isOpen: 1,
          startHour: "",
          closeHour: "",
          manager: ManagerEntity(id: 0, fullname: '', email: '', role: ''),
          region: RegionEntity(
            id: 0,
            nameAr: '',
            nameEn: '',
            managerId: 0,
            manager: ManagerEntity(id: 0, fullname: '', email: '', role: ''),
          ),
          services: [],
          createdAt: createdAt ?? DateTime.now(),
          updatedAt: updatedAt ?? DateTime.now(),
        ),

    packages: packages?.map((e) => e.toEntity()).toList() ?? [],

    attributes: attributes?.map((e) => e.toEntity()).toList() ?? [],

    reviews: reviews ?? [],

    images: images ?? [],
  );
}
