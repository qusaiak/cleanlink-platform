import 'package:json_annotation/json_annotation.dart';
import 'service_model.dart';
import '../../domain/entities/service_entity.dart';

part 'services_response_model.g.dart';

@JsonSerializable()
class ServicesResponseModel {
  final int status;
  final String message;
  final List<ServiceModel> data;

  const ServicesResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ServicesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ServicesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServicesResponseModelToJson(this);

  List<ServiceEntity> toEntity() {
    return data.map((e) => e.toEntity()).toList();
  }
}
