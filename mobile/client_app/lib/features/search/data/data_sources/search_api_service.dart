import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../models/search_response_model.dart';

part 'search_api_service.g.dart';

@RestApi()
abstract class SearchApiService {
  factory SearchApiService(Dio dio, {String baseUrl}) = _SearchApiService;

  @GET(ApiEndpoints.searchEndpoint)
  Future<HttpResponse<SearchResponseModel>> search(
    @Body() Map<String, dynamic> body,
  );
}
