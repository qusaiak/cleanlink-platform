import 'package:json_annotation/json_annotation.dart';

import '../../../auth/data/models/response/user_model.dart';
import '../../domain/entities/review_entity.dart';

part 'review_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewModel {
  final int id;

  final int clientId;

  final String comment;

  @JsonKey(fromJson: _ratingFromJson)
  final double rating;

  final int reviewableId;

  final String reviewableType;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final UserModel client;

  const ReviewModel({
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

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      clientId: clientId,
      comment: comment,
      rating: rating,
      reviewableId: reviewableId,
      reviewableType: reviewableType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      client: client.toEntity(),
    );
  }

  static double _ratingFromJson(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }
}
