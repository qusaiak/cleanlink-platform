import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/region_details_entity.dart';
import 'region_details_model.dart';

part 'region_details_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegionDetailsResponseModel {
  final int status;
  final String message;
  final RegionDetailsModel data;

  const RegionDetailsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegionDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegionDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionDetailsResponseModelToJson(this);

  RegionDetailsEntity toEntity() => data.toEntity();
}
