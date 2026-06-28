import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_entity.dart';
import 'home_data_model.dart';

part 'home_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeResponseModel {
  final int status;

  final String message;

  final HomeDataModel data;

  const HomeResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResponseModelToJson(this);

  HomeEntity toEntity() {
    return data.toEntity();
  }
}
