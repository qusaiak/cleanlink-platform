import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../models/complaint_models.dart';

part 'complaints_api_service.g.dart';

@RestApi()
abstract class ComplaintsApiService {
  factory ComplaintsApiService(Dio dio, {String baseUrl}) =
      _ComplaintsApiService;

  @GET(ApiEndpoints.complaintsEndpoint)
  Future<HttpResponse<ComplaintsResponseModel>> getComplaints();

  @GET('${ApiEndpoints.complaintsEndpoint}/{id}')
  Future<HttpResponse<ComplaintDetailsResponseModel>> getComplaintDetails(
    @Path('id') int id,
  );

  @POST(ApiEndpoints.complaintsEndpoint)
  Future<HttpResponse<ComplaintResponseModel>> createComplaint(
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiEndpoints.complaintUnreadCountEndpoint)
  Future<HttpResponse<ComplaintUnreadCountResponseModel>> getUnreadCount();

  @POST('${ApiEndpoints.complaintsEndpoint}/{id}/mark-read')
  Future<HttpResponse<ComplaintResponseModel>> markAsRead(@Path('id') int id);
}
