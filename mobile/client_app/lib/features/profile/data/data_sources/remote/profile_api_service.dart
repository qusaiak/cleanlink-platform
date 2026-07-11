import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../config/constants/api_endpoints.dart';
import '../../models/logout_response_model.dart';
import '../../models/update_profile_response_model.dart';

part 'profile_api_service.g.dart';

@RestApi()
abstract class ProfileApiService {
  factory ProfileApiService(Dio dio, {String baseUrl}) = _ProfileApiService;

  @MultiPart()
  @POST(ApiEndpoints.updateProfileEndpoint)
  Future<HttpResponse<UpdateProfileResponseModel>> updateProfile(
    @Part(name: 'fullname') String fullname,
    @Part(name: 'email') String email,
    @Part(name: 'address') String address,
    @Part(name: 'phone') String phone,
    @Part(name: 'image') File? image,
  );

  @POST(ApiEndpoints.logoutEndpoint)
  Future<HttpResponse<LogoutResponseModel>> logout();
}
