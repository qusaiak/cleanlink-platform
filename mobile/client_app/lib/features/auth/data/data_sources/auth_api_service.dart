import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/network/base_response_model.dart';
import '../models/request/change_password_request_model.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../models/request/resend_otp_request_model.dart';
import '../models/request/verify_otp_request_model.dart';
import '../models/response/auth_response_model.dart';
import '../models/response/otp_dispatch_response_model.dart';
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
  Future<HttpResponse<BaseResponseModel<OtpDispatchResponseModel>>> register(
    @Body() RegisterRequestModel body,
  );

  @POST(ApiEndpoints.verifyOtpEndpoint)
  Future<HttpResponse<BaseResponseModel<AuthResponseModel>>> verifyOtp(
    @Body() VerifyOtpRequestModel body,
  );

  @POST(ApiEndpoints.resendOtpEndpoint)
  Future<HttpResponse<BaseResponseModel<OtpDispatchResponseModel>>> resendOtp(
    @Body() ResendOtpRequestModel body,
  );

  @PUT(ApiEndpoints.changePasswordEndpoint)
  Future<HttpResponse<BaseResponseModel<dynamic>>> changePassword(
    @Body() ChangePasswordRequestModel body,
  );

  @MultiPart()
  @POST(ApiEndpoints.profileEndpoint)
  Future<HttpResponse<BaseResponseModel<UserProfileResponseModel>>>
  updateProfile(
    @Part(name: 'image') File? image,
    @Part(name: 'address') String address,
    @Part(name: 'phone') String phone,
  );
}
