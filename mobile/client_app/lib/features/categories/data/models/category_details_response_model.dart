import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/category_entity.dart';
import 'category_model.dart';

part 'category_details_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryDetailsResponseModel {
  final int status;
  final String message;
  final CategoryModel data;

  const CategoryDetailsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDetailsResponseModelToJson(this);

  CategoryEntity toEntity() => data.toEntity();
}
