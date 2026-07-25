import '../entities/review_submission_entity.dart';
import '../entities/my_review_entity.dart';
import '../usecases/add_review_use_case.dart';

abstract class ReviewsRepo {
  Future<ReviewSubmissionEntity> addReview(AddReviewParams params);

  Future<MyReviewsEntity> getMyReviews();
}
