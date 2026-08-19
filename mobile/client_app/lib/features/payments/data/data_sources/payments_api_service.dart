import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../models/payment_intent_models.dart';

part 'payments_api_service.g.dart';

@RestApi()
abstract class PaymentsApiService {
  factory PaymentsApiService(Dio dio, {String baseUrl}) = _PaymentsApiService;

  @POST(ApiEndpoints.createPaymentIntentEndpoint)
  Future<HttpResponse<CreatePaymentIntentResponseModel>> createPaymentIntent(
    @Body() CreatePaymentIntentRequestModel body,
  );
}
