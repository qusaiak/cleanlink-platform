import 'package:dio/dio.dart';

import '../../../../config/constants/api_endpoints.dart';

class ClientPaymentsApiService {
  const ClientPaymentsApiService(this.dio);
  final Dio dio;

  Future<Map<String, dynamic>> getClientPayments({
    required int page,
    required int perPage,
    String? status,
    String? paymentMethod,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      ApiEndpoints.clientPaymentsEndpoint,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'status': ?status,
        'payment_method': ?paymentMethod,
      },
    );
    final data = response.data;
    if (data == null) throw const FormatException('Empty payments response');
    return data;
  }

  Future<Map<String, dynamic>> getClientPayment(int paymentId) async {
    final response = await dio.get<Map<String, dynamic>>(
      ApiEndpoints.clientPaymentDetailsEndpoint.replaceFirst(
        '{paymentId}',
        '$paymentId',
      ),
    );
    final data = response.data;
    if (data == null) throw const FormatException('Empty payment response');
    return data;
  }
}
