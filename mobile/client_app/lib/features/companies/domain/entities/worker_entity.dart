import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_entity.dart';

class WorkerEntity extends Equatable {
  final int id;
  final int userId;
  final int companyId;

  final int experienceYears;

  final double rating;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final UserEntity user;

  const WorkerEntity({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.experienceYears,
    required this.rating,
    required this.user,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    companyId,
    experienceYears,
    rating,
    createdAt,
    updatedAt,
    user,
  ];

  WorkerEntity copyWith({
    int? id,
    int? userId,
    int? companyId,
    int? experienceYears,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserEntity? user,
  }) {
    return WorkerEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      experienceYears: experienceYears ?? this.experienceYears,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}
