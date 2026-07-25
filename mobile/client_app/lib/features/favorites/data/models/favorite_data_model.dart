import 'package:json_annotation/json_annotation.dart';

import '../../../companies/data/models/company_model.dart';
import '../../../services/data/models/service_model.dart';
import '../../domain/entities/favorite_entity.dart';

part 'favorite_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FavoriteDataModel {
  final List<ServiceModel>? services;

  final List<CompanyModel>? companies;

  const FavoriteDataModel({this.services, this.companies});

  factory FavoriteDataModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteDataModelToJson(this);

  FavoriteEntity toEntity() {
    return FavoriteEntity(
      services: services?.map((e) => e.toEntity()).toList() ?? [],

      companies: companies?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
