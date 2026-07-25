import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../config/language/app_language_info.dart';
import '../../domain/entities/my_review_entity.dart';
import '../../domain/entities/review_submission_entity.dart';
import '../../domain/repositories/reviews_repo.dart';
import '../../domain/usecases/add_review_use_case.dart';
import '../data_sources/reviews_api_service.dart';
import '../models/review_request_model.dart';

class ReviewsRepoImpl implements ReviewsRepo {
  final ReviewsApiService api;

  const ReviewsRepoImpl(this.api);

  @override
  Future<ReviewSubmissionEntity> addReview(AddReviewParams params) async {
    try {
      final response = await api.addReview(
        ReviewRequestModel.fromParams(params),
      );
      final httpStatus = response.response.statusCode ?? 0;
      final applicationStatus = response.data.status ?? httpStatus;
      if (httpStatus < 200 ||
          httpStatus >= 300 ||
          applicationStatus < 200 ||
          applicationStatus >= 300) {
        throw ServerFailure(
          response.data.message ?? 'Unable to submit review',
          applicationStatus.toString(),
        );
      }
      return response.data.toEntity(fallbackStatus: httpStatus);
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<MyReviewsEntity> getMyReviews() async {
    try {
      final response = await api.getMyReviews();
      final httpStatus = response.response.statusCode ?? 0;
      final body = response.data;
      if (httpStatus < 200 ||
          httpStatus >= 300 ||
          body.status < 200 ||
          body.status >= 300 ||
          body.data == null) {
        throw ServerFailure(body.message, body.status.toString());
      }
      return body.data!.toEntity(languageCode: AppLanguageInfo.languageCode);
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ServerFailure('Could not load your reviews', '');
    }
  }
}
