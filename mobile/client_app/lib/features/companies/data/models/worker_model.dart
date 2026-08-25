import 'package:json_annotation/json_annotation.dart';

import '../../../auth/data/models/response/user_model.dart';
import '../../domain/entities/worker_entity.dart';

part 'worker_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WorkerModel {
  final int id;

  final int userId;

  final int companyId;

  final int experienceYears;

  final double rating;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final UserModel user;

  const WorkerModel({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.experienceYears,
    required this.rating,
    required this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerModelToJson(this);

  WorkerEntity toEntity() {
    return WorkerEntity(
      id: id,
      userId: userId,
      companyId: companyId,
      experienceYears: experienceYears,
      rating: rating,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user.toEntity(),
    );
  }
}
