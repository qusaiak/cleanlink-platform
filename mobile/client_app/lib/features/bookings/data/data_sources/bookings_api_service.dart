import 'package:client_app/config/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/available_slots_response_model.dart';
import '../models/book_order_request_model.dart';
import '../models/order_response_models.dart';
import '../models/open_package_models.dart';

part 'bookings_api_service.g.dart';

@RestApi()
abstract class BookingsApiService {
  factory BookingsApiService(Dio dio, {String baseUrl}) = _BookingsApiService;

  @GET(ApiEndpoints.packageAvailableSlotsEndpoint)
  Future<HttpResponse<AvailableSlotsResponseModel>> getAvailableSlots(
    @Path("id") int packageId,
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
  );

  @POST(ApiEndpoints.openPackageCheckPriceEndpoint)
  Future<HttpResponse<OpenPackageQuoteResponseModel>> checkOpenPackagePrice(
    @Path('id') int packageId,
    @Body() OpenPackageAttributesRequestModel body,
  );

  @POST(ApiEndpoints.openPackageAvailableSlotsEndpoint)
  Future<HttpResponse<OpenPackageSlotsResponseModel>>
  getOpenPackageAvailableSlots(
    @Path('id') int packageId,
    @Body() OpenPackageSlotsRequestModel body,
  );

  @GET(ApiEndpoints.ordersEndpoint)
  Future<HttpResponse<GetOrdersResponseModel>> getOrders({
    @Query('page') required int page,
    @Query('per_page') required int perPage,
  });

  @POST(ApiEndpoints.ordersEndpoint)
  Future<HttpResponse<BookOrderResponseModel>> bookOrder(
    @Body() BookOrderRequestModel body,
  );

  @POST(ApiEndpoints.openPackageOrdersEndpoint)
  Future<HttpResponse<BookOrderResponseModel>> bookOpenPackage(
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
