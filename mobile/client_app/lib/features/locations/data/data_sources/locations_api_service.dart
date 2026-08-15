import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../models/location_request_model.dart';
import '../models/locations_response_model.dart';

part 'locations_api_service.g.dart';

@RestApi()
abstract class LocationsApiService {
  factory LocationsApiService(Dio dio, {String? baseUrl}) =
      _LocationsApiService;

  @GET(ApiEndpoints.locationsEndpoint)
  Future<HttpResponse<LocationsResponseModel>> getLocations();

  @POST(ApiEndpoints.locationsEndpoint)
  Future<HttpResponse<LocationResponseModel>> addLocation(
    @Body() LocationRequestModel request,
  );

  @PUT('${ApiEndpoints.locationsEndpoint}/{id}')
  Future<HttpResponse<LocationResponseModel>> updateLocation(
    @Path('id') int id,
    @Body() LocationRequestModel request,
  );

  @DELETE('${ApiEndpoints.locationsEndpoint}/{id}')
  Future<HttpResponse<DeleteLocationResponseModel>> deleteLocation(
    @Path('id') int id,
  );
}
