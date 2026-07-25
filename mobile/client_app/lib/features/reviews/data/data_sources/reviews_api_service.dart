import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../models/review_request_model.dart';
import '../models/review_response_model.dart';
import '../models/my_reviews_response_model.dart';

part 'reviews_api_service.g.dart';

@RestApi()
abstract class ReviewsApiService {
  factory ReviewsApiService(Dio dio, {String baseUrl}) = _ReviewsApiService;

  @POST(ApiEndpoints.reviewsEndpoint)
  Future<HttpResponse<ReviewResponseModel>> addReview(
    @Body() ReviewRequestModel request,
  );

  @GET(ApiEndpoints.myReviewsEndpoint)
  Future<HttpResponse<MyReviewsResponseModel>> getMyReviews();
}
