import 'package:client_app/features/services/data/models/service_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/category_entity.dart';
import 'category_service_model.dart';

part 'category_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryModel {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final List<ServiceModel>? services;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.services,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  CategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    List<ServiceModel>? services,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      services: services ?? this.services,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CategoryEntity toEntity() => CategoryEntity(
    id: id ?? 0,
    name: name ?? "",
    description: description ?? "",
    image: image ?? "",
    services: services?.map((e) => e.toEntity()).toList() ?? const [],
  );
}
