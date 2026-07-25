import 'package:json_annotation/json_annotation.dart';

import '../../../companies/data/models/company_model.dart';
import '../../../companies/data/models/manager_model.dart';
import '../../domain/entities/region_details_entity.dart';

part 'region_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegionDetailsModel {
  final int? id;
  final String? name;
  final String? image;
  final ManagerModel? manager;
  final List<CompanyModel>? companies;

  const RegionDetailsModel({
    this.id,
    this.name,
    this.image,
    this.manager,
    this.companies,
  });

  factory RegionDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RegionDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionDetailsModelToJson(this);

  RegionDetailsEntity toEntity() => RegionDetailsEntity(
    id: id ?? 0,
    name: name ?? "",
    image: image ?? "",
    manager: manager?.toEntity(),
    companies: companies?.map((e) => e.toEntity()).toList() ?? const [],
  );
}
