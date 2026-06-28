import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../models/categories_response_model.dart';

part 'categories_api_service.g.dart';

@RestApi()
abstract class CategoriesApiService {
  factory CategoriesApiService(Dio dio, {String baseUrl}) =
      _CategoriesApiService;

  @GET(ApiEndpoints.categoriesEndpoint)
  Future<HttpResponse<CategoriesResponseModel>> getCategories();
}
