import '../entities/my_review_entity.dart';
import '../repositories/reviews_repo.dart';

class GetMyReviewsUseCase {
  final ReviewsRepo repo;

  const GetMyReviewsUseCase(this.repo);

  Future<MyReviewsEntity> call() => repo.getMyReviews();
}
