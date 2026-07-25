import 'package:json_annotation/json_annotation.dart';

import 'service_model.dart';

part 'service_details_response_model.g.dart';

@JsonSerializable()
class ServiceDetailsResponseModel {
  final int status;

  final String message;

  final ServiceModel data;

  const ServiceDetailsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ServiceDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDetailsResponseModelToJson(this);
}
