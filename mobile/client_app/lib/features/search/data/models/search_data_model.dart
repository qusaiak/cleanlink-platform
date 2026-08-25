import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/search_entity.dart';

import '../../../categories/data/models/category_model.dart';
import '../../../companies/data/models/company_model.dart';
import '../../../regions/data/models/region_model.dart';
import '../../../services/data/models/service_model.dart';

part 'search_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class SearchDataModel {
  final List<RegionModel>? regions;

  final List<CategoryModel>? categories;

  final List<CompanyModel>? companies;

  final List<ServiceModel>? services;

  final List<ServiceModel>? offers;

  const SearchDataModel({
    this.regions,

    this.categories,

    this.companies,

    this.services,

    this.offers,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) =>
      _$SearchDataModelFromJson(json);

  SearchEntity toEntity() {
    return SearchEntity(
      regions: regions?.map((e) => e.toEntity()).toList() ?? [],

      categories: categories?.map((e) => e.toEntity()).toList() ?? [],

      companies: companies?.map((e) => e.toEntity()).toList() ?? [],

      services: services?.map((e) => e.toEntity()).toList() ?? [],

      offers: offers?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
