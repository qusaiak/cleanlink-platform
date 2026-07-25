import 'package:client_app/config/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/available_slots_response_model.dart';
import '../models/book_order_request_model.dart';
import '../models/order_response_models.dart';

part 'bookings_api_service.g.dart';

@RestApi()
abstract class BookingsApiService {
  factory BookingsApiService(Dio dio, {String baseUrl}) = _BookingsApiService;

  @GET(ApiEndpoints.packageAvailableSlotsEndpoint)
  Future<HttpResponse<AvailableSlotsResponseModel>> getAvailableSlots(
    @Path("id") int packageId,
  );

  @GET(ApiEndpoints.ordersEndpoint)
  Future<HttpResponse<GetOrdersResponseModel>> getOrders();

  @POST(ApiEndpoints.ordersEndpoint)
  Future<HttpResponse<BookOrderResponseModel>> bookOrder(
    @Body() BookOrderRequestModel body,
  );

  @GET(ApiEndpoints.showOrderEndpoint)
  Future<HttpResponse<ShowOrderResponseModel>> showOrder(
    @Path('orderId') int orderId,
  );

  @POST(ApiEndpoints.cancelOrderEndpoint)
  Future<HttpResponse<CancelOrderResponseModel>> cancelOrder(
    @Path('orderId') int orderId,
  );
}
