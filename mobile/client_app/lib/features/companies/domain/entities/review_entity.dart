import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_entity.dart';

class ReviewEntity extends Equatable {
  final int id;

  final int clientId;

  final String comment;

  final double rating;

  final int reviewableId;

  final String reviewableType;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final UserEntity client;

  const ReviewEntity({
    required this.id,
    required this.clientId,
    required this.comment,
    required this.rating,
    required this.reviewableId,
    required this.reviewableType,
    required this.client,
    this.createdAt,
    this.updatedAt,
  });

  ReviewEntity copyWith({
    int? id,
    int? clientId,
    String? comment,
    double? rating,
    int? reviewableId,
    String? reviewableType,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserEntity? client,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      reviewableId: reviewableId ?? this.reviewableId,
      reviewableType: reviewableType ?? this.reviewableType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      client: client ?? this.client,
    );
  }

  @override
  List<Object?> get props => [
    id,
    clientId,
    comment,
    rating,
    reviewableId,
    reviewableType,
    createdAt,
    updatedAt,
    client,
  ];
}
