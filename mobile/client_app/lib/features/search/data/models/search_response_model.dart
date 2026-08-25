import 'package:json_annotation/json_annotation.dart';

import 'search_data_model.dart';

part 'search_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SearchResponseModel {
  final int? status;

  final String? message;

  final SearchDataModel? data;

  const SearchResponseModel({this.status, this.message, this.data});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);
}
