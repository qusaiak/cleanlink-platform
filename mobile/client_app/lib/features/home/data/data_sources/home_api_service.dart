import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../config/constants/api_endpoints.dart';
import '../models/home_response_model.dart';

part 'home_api_service.g.dart';

@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  @GET(ApiEndpoints.homeEndpoint)
  Future<HttpResponse<HomeResponseModel>> getHome();
}
