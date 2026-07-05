// import 'package:json_annotation/json_annotation.dart';
//
// import '../../domain/entities/category_service_entity.dart';
//
// part 'category_service_model.g.dart';
//
// @JsonSerializable(fieldRename: FieldRename.snake)
// class CategoryServiceModel {
//   final int? id;
//   final int? companyId;
//   final int? categoryId;
//   final String? name;
//   final String? description;
//   final String? rating;
//   final int? minDuration;
//   final int? maxDuration;
//   final String? price;
//   final String? image;
//   final String? discount;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   const CategoryServiceModel({
//     this.id,
//     this.companyId,
//     this.categoryId,
//     this.name,
//     this.description,
//     this.rating,
//     this.minDuration,
//     this.maxDuration,
//     this.price,
//     this.image,
//     this.discount,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory CategoryServiceModel.fromJson(Map<String, dynamic> json) =>
//       _$CategoryServiceModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$CategoryServiceModelToJson(this);
//
//   CategoryServiceModel copyWith({
//     int? id,
//     int? companyId,
//     int? categoryId,
//     String? name,
//     String? description,
//     String? rating,
//     int? minDuration,
//     int? maxDuration,
//     String? price,
//     String? image,
//     String? discount,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return CategoryServiceModel(
//       id: id ?? this.id,
//       companyId: companyId ?? this.companyId,
//       categoryId: categoryId ?? this.categoryId,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       rating: rating ?? this.rating,
//       minDuration: minDuration ?? this.minDuration,
//       maxDuration: maxDuration ?? this.maxDuration,
//       price: price ?? this.price,
//       image: image ?? this.image,
//       discount: discount ?? this.discount,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
//
//   CategoryServiceEntity toEntity() => CategoryServiceEntity(
//         id: id ?? 0,
//         companyId: companyId ?? 0,
//         categoryId: categoryId ?? 0,
//         name: name ?? "",
//         description: description ?? "",
//         rating: rating ?? "0",
//         minDuration: minDuration ?? 0,
//         maxDuration: maxDuration ?? 0,
//         price: price ?? "0",
//         image: image ?? "",
//         discount: discount ?? "0",
//       );
// }
