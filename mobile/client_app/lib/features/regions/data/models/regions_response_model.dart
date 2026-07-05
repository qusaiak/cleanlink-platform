import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/region_entity.dart';
import 'region_model.dart';

part 'regions_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegionsResponseModel {
  final int status;
  final String message;
  final List<RegionModel> data;

  const RegionsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegionsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegionsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionsResponseModelToJson(this);

  List<RegionEntity> toEntity() => data.map((e) => e.toEntity()).toList();
}
