import 'package:json_annotation/json_annotation.dart';

import 'category_model.dart';
import '../../domain/entities/category_entity.dart';


part 'categories_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoriesResponseModel {
  final int status;

  final String message;

  final List<CategoryModel> data;

  const CategoriesResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoriesResponseModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$CategoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CategoriesResponseModelToJson(this);

  List<CategoryEntity> toEntity() {
    return data
        .map((e) => e.toEntity())
        .toList();
  }
}