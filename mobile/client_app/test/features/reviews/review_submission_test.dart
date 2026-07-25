import 'dart:async';

import 'package:client_app/features/reviews/data/data_sources/reviews_api_service.dart';
import 'package:client_app/core/error/failure.dart';
import 'package:client_app/features/reviews/data/models/review_request_model.dart';
import 'package:client_app/features/reviews/data/models/review_response_model.dart';
import 'package:client_app/features/reviews/data/models/my_reviews_response_model.dart';
import 'package:client_app/features/reviews/data/repositories/reviews_repo_impl.dart';
import 'package:client_app/features/reviews/domain/entities/review_submission_entity.dart';
import 'package:client_app/features/reviews/domain/entities/my_review_entity.dart';
import 'package:client_app/features/reviews/domain/entities/reviewable_type.dart';
import 'package:client_app/features/reviews/domain/repositories/reviews_repo.dart';
import 'package:client_app/features/reviews/domain/usecases/add_review_use_case.dart';
import 'package:client_app/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

void main() {
  test('builds the correct company request', () {
    final request = ReviewRequestModel.fromParams(
      const AddReviewParams(
        type: ReviewableType.company,
        id: 7,
        rating: 5,
        comment: 'Great',
      ),
    );
    expect(request.toJson(), {
      'type': 'company',
      'id': 7,
      'rating': 5,
      'comment': 'Great',
    });
  });

  test('builds the correct service request', () {
    final request = ReviewRequestModel.fromParams(
      const AddReviewParams(type: ReviewableType.service, id: 3, rating: 4),
    );
    expect(request.toJson()['type'], 'service');
    expect(request.toJson()['id'], 3);
  });

  test('empty trimmed comment becomes null', () {
    final request = ReviewRequestModel.fromParams(
      const AddReviewParams(
        type: ReviewableType.service,
        id: 3,
        rating: 4,
        comment: '   ',
      ),
    );
    expect(request.toJson()['comment'], isNull);
  });

  test('successful status 211 is accepted', () async {
    final repo = ReviewsRepoImpl(
      _FakeReviewsApi(
        response: const ReviewResponseModel(
          status: 211,
          message: 'Review submitted successfully',
          reviewId: 61,
        ),
        httpStatus: 211,
      ),
    );

    final result = await repo.addReview(
      const AddReviewParams(type: ReviewableType.company, id: 1, rating: 5),
    );

    expect(result.status, 211);
    expect(result.reviewId, 61);
  });

  test('403 backend message is propagated', () async {
    final repo = ReviewsRepoImpl(
      _FakeReviewsApi(
        response: const ReviewResponseModel(),
        httpStatus: 403,
        errorMessage: 'Only clients who used this can review!',
      ),
    );

    expect(
      () => repo.addReview(
        const AddReviewParams(type: ReviewableType.service, id: 1, rating: 5),
      ),
      throwsA(
        isA<ServerFailure>().having(
          (error) => error.message,
          'message',
          contains('Only clients who used this can review!'),
        ),
      ),
    );
  });

  test('duplicate submission is prevented while a request is active', () async {
    final repo = _PendingReviewsRepo();
    final bloc = ReviewBloc(AddReviewUseCase(repo));
    const params = AddReviewParams(
      type: ReviewableType.company,
      id: 1,
      rating: 5,
    );

    bloc
      ..add(const SubmitReviewEvent(params))
      ..add(const SubmitReviewEvent(params));
    await Future<void>.delayed(Duration.zero);
    expect(repo.calls, 1);

    repo.completer.complete(
      const ReviewSubmissionEntity(status: 211, message: 'Success'),
    );
    await bloc.stream.firstWhere((state) => state.result != null);
    expect(bloc.state.result?.status, 211);
    await bloc.close();
  });
}

class _FakeReviewsApi implements ReviewsApiService {
  final ReviewResponseModel response;
  final int httpStatus;
  final String? errorMessage;

  _FakeReviewsApi({
    required this.response,
    required this.httpStatus,
    this.errorMessage,
  });

  @override
  Future<HttpResponse<ReviewResponseModel>> addReview(
    ReviewRequestModel request,
  ) async {
    final options = RequestOptions(path: '/reviews');
    if (errorMessage != null) {
      final dioResponse = Response<Map<String, dynamic>>(
        requestOptions: options,
        statusCode: httpStatus,
        data: {'status': httpStatus, 'message': errorMessage},
      );
      throw DioException(
        requestOptions: options,
        response: dioResponse,
        type: DioExceptionType.badResponse,
      );
    }
    return HttpResponse(
      response,
      Response<void>(requestOptions: options, statusCode: httpStatus),
    );
  }

  @override
  Future<HttpResponse<MyReviewsResponseModel>> getMyReviews() {
    throw UnimplementedError();
  }
}

class _PendingReviewsRepo implements ReviewsRepo {
  int calls = 0;
  final Completer<ReviewSubmissionEntity> completer = Completer();

  @override
  Future<ReviewSubmissionEntity> addReview(AddReviewParams params) {
    calls += 1;
    return completer.future;
  }

  @override
  Future<MyReviewsEntity> getMyReviews() async => const MyReviewsEntity();
}
