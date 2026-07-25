import 'package:json_annotation/json_annotation.dart';

import 'favorite_data_model.dart';

part 'favorite_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FavoriteResponseModel {
  final int? status;

  final String? message;

  final FavoriteDataModel? data;

  const FavoriteResponseModel({this.status, this.message, this.data});

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteResponseModelToJson(this);
}
