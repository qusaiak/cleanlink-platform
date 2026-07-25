import 'package:equatable/equatable.dart';

import '../entities/review_submission_entity.dart';
import '../entities/reviewable_type.dart';
import '../repositories/reviews_repo.dart';

class AddReviewParams extends Equatable {
  final ReviewableType type;
  final int id;
  final int rating;
  final String? comment;

  const AddReviewParams({
    required this.type,
    required this.id,
    required this.rating,
    this.comment,
  });

  AddReviewParams normalized() {
    final normalizedComment = comment?.trim() ?? '';
    return AddReviewParams(
      type: type,
      id: id,
      rating: rating,
      comment: normalizedComment.isEmpty ? null : normalizedComment,
    );
  }

  @override
  List<Object?> get props => [type, id, rating, comment];
}

class AddReviewUseCase {
  final ReviewsRepo repo;

  const AddReviewUseCase(this.repo);

  Future<ReviewSubmissionEntity> call(AddReviewParams params) {
    if (params.rating < 1 || params.rating > 5) {
      throw const FormatException('Rating must be between 1 and 5');
    }
    return repo.addReview(params.normalized());
  }
}
