import '../../domain/entities/reviewable_type.dart';
import '../../domain/usecases/add_review_use_case.dart';

class ReviewRequestModel {
  final ReviewableType type;
  final int id;
  final int rating;
  final String? comment;

  const ReviewRequestModel({
    required this.type,
    required this.id,
    required this.rating,
    this.comment,
  });

  factory ReviewRequestModel.fromParams(AddReviewParams params) {
    final normalized = params.normalized();
    return ReviewRequestModel(
      type: normalized.type,
      id: normalized.id,
      rating: normalized.rating,
      comment: normalized.comment,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.apiValue,
    'id': id,
    'rating': rating,
    'comment': comment,
  };
}
