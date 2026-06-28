import 'package:client_app/features/services/data/models/service_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_entity.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../companies/data/models/company_model.dart';

part 'home_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeDataModel {
  final List<ServiceModel>? offers;

  final List<ServiceModel>? services;

  final List<CategoryModel>? categories;

  final List<CompanyModel>? companies;

  const HomeDataModel({
    this.offers,
    this.services,
    this.categories,
    this.companies,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataModelToJson(this);

  HomeEntity toEntity() => HomeEntity(
    offers: offers?.map((e) => e.toEntity()).toList() ?? [],

    services: services?.map((e) => e.toEntity()).toList() ?? [],

    categories: categories?.map((e) => e.toEntity()).toList() ?? [],

    companies: companies?.map((e) => e.toEntity()).toList() ?? [],
  );
}
