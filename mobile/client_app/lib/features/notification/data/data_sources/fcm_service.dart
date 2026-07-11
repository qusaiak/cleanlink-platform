import 'package:client_app/config/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/update_fcm_token_request_model.dart';
import '../models/notification_models.dart';

part 'fcm_service.g.dart';

@RestApi()
abstract class NotificationsApiService {
  factory NotificationsApiService(Dio dio, {String baseUrl}) =
      _NotificationsApiService;

  @POST(ApiEndpoints.updateFcmTokenEndpoint)
  Future<HttpResponse<UpdateFcmTokenResponseModel>> updateFcmToken(
    @Body() UpdateFcmTokenRequestModel body,
  );

  @GET(ApiEndpoints.notificationsEndpoint)
  Future<HttpResponse<GetNotificationsResponseModel>> getNotifications();

  @GET(ApiEndpoints.unreadNotificationsCountEndpoint)
  Future<HttpResponse<UnreadNotificationsCountResponseModel>>
  getUnreadNotificationsCount();

  @POST('${ApiEndpoints.notificationsEndpoint}/{notificationId}/mark-as-read')
  Future<HttpResponse<MarkNotificationAsReadResponseModel>> markAsRead(
    @Path('notificationId') int notificationId,
  );
}
