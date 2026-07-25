import 'package:json_annotation/json_annotation.dart';

import 'company_model.dart';
import '../../domain/entities/company_entity.dart';

part 'company_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CompanyResponseModel {
  final int status;

  final String message;

  final List<CompanyModel> data;

  const CompanyResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyResponseModelToJson(this);

  List<CompanyEntity> toEntity() {
    return data.map((e) => e.toEntity()).toList();
  }
}
