import 'package:json_annotation/json_annotation.dart';

import 'company_model.dart';


part 'company_details_response_model.g.dart';

@JsonSerializable()
class CompanyDetailsResponseModel {
  final int status;

  final String message;

  final CompanyModel data;

  const CompanyDetailsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CompanyDetailsResponseModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$CompanyDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CompanyDetailsResponseModelToJson(this);
}