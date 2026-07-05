import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../models/region_details_response_model.dart';
import '../models/regions_response_model.dart';

part 'regions_api_service.g.dart';

@RestApi()
abstract class RegionsApiService {
  factory RegionsApiService(Dio dio, {String baseUrl}) = _RegionsApiService;

  @GET(ApiEndpoints.regionsEndpoint)
  Future<HttpResponse<RegionsResponseModel>> getRegions();

  @GET(ApiEndpoints.regionNamesEndpoint)
  Future<HttpResponse<RegionsResponseModel>> getRegionNames();

  @GET("${ApiEndpoints.regionsEndpoint}/{id}")
  Future<HttpResponse<RegionDetailsResponseModel>> getRegion(
    @Path("id") int id,
  );
}
