import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/payment_entities.dart';
import '../../domain/repositories/payments_repository.dart';
import '../data_sources/payments_api_service.dart';
import '../data_sources/client_payments_api_service.dart';
import '../models/payment_intent_models.dart';
import '../models/client_payment_models.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  const PaymentsRepositoryImpl(this.api, this.clientApi);
  final PaymentsApiService api;
  final ClientPaymentsApiService clientApi;

  @override
  Future<PaymentIntentEntity> createPaymentIntent({
    required int orderId,
  }) async {
    try {
      final response = await api.createPaymentIntent(
        CreatePaymentIntentRequestModel(orderId),
      );
      final body = response.data;
      final httpStatus = response.response.statusCode ?? 0;
      if (httpStatus < 200 ||
          httpStatus >= 300 ||
          body.status < 200 ||
          body.status >= 300 ||
          body.data == null ||
          body.data!.clientSecret.isEmpty) {
        throw ServerFailure(body.message, body.status.toString());
      }
      return body.data!.toEntity();
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<ClientPaymentsPage> getClientPayments({
    required int page,
    required int perPage,
    String? status,
    String? paymentMethod,
  }) async {
    try {
      final response = await clientApi.getClientPayments(
        page: page,
        perPage: perPage,
        status: status,
        paymentMethod: paymentMethod,
      );
      final model = ClientPaymentsResponseModel.fromJson(response);
      if (model.status < 200 || model.status >= 300) {
        throw ServerFailure(model.message, model.status.toString());
      }
      return model.data;
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<ClientPaymentEntity> getClientPayment(int paymentId) async {
    try {
      final response = await clientApi.getClientPayment(paymentId);
      final model = ClientPaymentResponseModel.fromJson(response);
      if (model.status < 200 || model.status >= 300) {
        throw ServerFailure(model.message, model.status.toString());
      }
      return model.data;
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }
}
