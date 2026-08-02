import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../models/categories_response_model.dart';
import '../models/category_details_response_model.dart';

part 'categories_api_service.g.dart';

@RestApi()
abstract class CategoriesApiService {
  factory CategoriesApiService(Dio dio, {String baseUrl}) =
      _CategoriesApiService;

  @GET(ApiEndpoints.categoriesEndpoint)
  Future<HttpResponse<CategoriesResponseModel>> getCategories({
    @Query('page') required int page,
    @Query('per_page') required int perPage,
  });

  @GET("${ApiEndpoints.categoriesEndpoint}/{id}")
  Future<HttpResponse<CategoryDetailsResponseModel>> getCategory(
    @Path("id") int id,
  );
}
