import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../config/constants/api_endpoints.dart';
import '../models/service_details_response_model.dart';
import '../models/services_response_model.dart';

part 'services_api_service.g.dart';

@RestApi()
abstract class ServicesApiService {
  factory ServicesApiService(Dio dio, {String baseUrl}) = _ServicesApiService;

  @GET(ApiEndpoints.servicesEndpoint)
  Future<HttpResponse<ServicesResponseModel>> getServices({
    @Query('page') required int page,
    @Query('per_page') required int perPage,
  });

  @GET(ApiEndpoints.offersEndpoint)
  Future<HttpResponse<ServicesResponseModel>> getOffers({
    @Query('page') required int page,
    @Query('per_page') required int perPage,
  });

  @GET("${ApiEndpoints.servicesEndpoint}/{id}")
  Future<HttpResponse<ServiceDetailsResponseModel>> getServiceDetails(
    @Path("id") int id,
  );
}
