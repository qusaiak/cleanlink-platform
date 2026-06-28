// import 'package:flutter/material.dart';
//
// class CategoryModel {
//   final IconData icon;
//   final String title;
//
//   const CategoryModel({
//     required this.icon,
//     required this.title,
//   });
// }
//
// class CategoriesData {
//   static final List<CategoryModel> all = [
//     CategoryModel(icon: Icons.home, title: "Home"),
//     CategoryModel(icon: Icons.business, title: "Office"),
//     CategoryModel(icon: Icons.auto_awesome, title: "Deep"),
//     CategoryModel(icon: Icons.chair, title: "Sofa"),
//     CategoryModel(icon: Icons.cleaning_services, title: "Carpet"),
//     CategoryModel(icon: Icons.local_shipping, title: "Move"),
//
//     /// Extra categories (only visible in full page)
//     CategoryModel(icon: Icons.kitchen, title: "Kitchen"),
//     CategoryModel(icon: Icons.bathtub, title: "Bathroom"),
//     CategoryModel(icon: Icons.window, title: "Windows"),
//     CategoryModel(icon: Icons.yard, title: "Garden"),
//     CategoryModel(icon: Icons.pool, title: "Pool"),
//     CategoryModel(icon: Icons.ac_unit, title: "AC Cleaning"),
//   ];
// }
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/category_entity.dart';

part 'category_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryModel {
  final int? id;

  final String? nameAr;

  final String? nameEn;

  final String? descriptionAr;

  final String? descriptionEn;

  final String? image;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  const CategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  CategoryEntity toEntity() => CategoryEntity(
    id: id ?? 0,
    nameAr: nameAr ?? "",
    nameEn: nameEn ?? "",
    descriptionAr: descriptionAr ?? "",
    descriptionEn: descriptionEn ?? "",
    image: image ?? "",
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
