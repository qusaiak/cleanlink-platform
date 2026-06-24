import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/network/base_response_model.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../models/request/user_profile_request_model.dart';
import '../models/response/auth_response_model.dart';
import '../models/response/user_profile_response_model.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST(ApiEndpoints.loginEndpoint)
  Future<HttpResponse<BaseResponseModel<AuthResponseModel>>> login(
    @Body() LoginRequestModel body,
  );

  @POST(ApiEndpoints.registerEndpoint)
  Future<HttpResponse<BaseResponseModel<AuthResponseModel>>> register(
    @Body() RegisterRequestModel body,
  );

  @PUT(ApiEndpoints.profileEndpoint)
  Future<HttpResponse<BaseResponseModel<UserProfileResponseModel>>> updateProfile(
    @Header('Authorization') String token,
    @Body() UserProfileRequestModel body,
  );
}
