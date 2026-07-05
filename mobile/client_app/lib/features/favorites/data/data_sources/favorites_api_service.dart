import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';

import '../models/favorite_response_model.dart';
import '../models/favorite_toggle_model.dart';

part 'favorites_api_service.g.dart';

@RestApi()
abstract class FavoritesApiService {
  factory FavoritesApiService(Dio dio, {String baseUrl}) = _FavoritesApiService;

  @GET(ApiEndpoints.favoritesEndpoint)
  Future<HttpResponse<FavoriteResponseModel>> getFavorites();

  @POST(ApiEndpoints.toggleFavoriteEndpoint)
  Future<HttpResponse<FavoriteToggleModel>> toggleFavorite(
    @Body() Map<String, dynamic> body,
  );
}
