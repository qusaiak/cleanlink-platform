import '../../domain/entities/payment_entities.dart';

class ClientPaymentsResponseModel {
  const ClientPaymentsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final ClientPaymentsPage data;

  factory ClientPaymentsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawMeta = json['meta'];
    if (rawData is! List || rawMeta is! Map<String, dynamic>) {
      throw const FormatException('Invalid client payments response');
    }
    return ClientPaymentsResponseModel(
      status: _int(json['status']),
      message: json['message']?.toString() ?? '',
      data: ClientPaymentsPage(
        items: rawData
            .whereType<Map<String, dynamic>>()
            .map(ClientPaymentModel.fromListJson)
            .toList(growable: false),
        currentPage: _int(rawMeta['current_page'], fallback: 1),
        lastPage: _int(rawMeta['last_page'], fallback: 1),
        perPage: _int(rawMeta['per_page'], fallback: 10),
        total: _int(rawMeta['total']),
      ),
    );
  }
}

class ClientPaymentResponseModel {
  const ClientPaymentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final ClientPaymentEntity data;

  factory ClientPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is! Map<String, dynamic>) {
      throw const FormatException('Invalid client payment response');
    }
    return ClientPaymentResponseModel(
      status: _int(json['status']),
      message: json['message']?.toString() ?? '',
      data: ClientPaymentModel.fromDetailsJson(rawData),
    );
  }
}

abstract final class ClientPaymentModel {
  static ClientPaymentEntity fromListJson(Map<String, dynamic> json) =>
      fromJson(json);

  static ClientPaymentEntity fromDetailsJson(Map<String, dynamic> json) =>
      fromJson(json);

  static ClientPaymentEntity fromJson(Map<String, dynamic> json) {
    final service = _map(json['service']);
    final company = _map(json['company']);
    final package = _map(json['package']);
    final id = _int(json['id']);
    return ClientPaymentEntity(
      id: id,
      orderId: _int(json['order_id']),
      orderStatus: json['order_status']?.toString() ?? '',
      amount: _double(json['amount']),
      currency: json['currency']?.toString() ?? 'USD',
      paymentMethod: paymentMethodFromApi(json['payment_method']?.toString()),
      paymentStatus: paymentStatusFromApi(json['payment_status']?.toString()),
      createdAt: _date(json['created_at']),
      bookingDate: _date(json['booking_date']),
      paidAt: _date(json['paid_at']),
      serviceId: _nullableInt(service?['id']),
      serviceName: service?['name']?.toString(),
      serviceNameAr: service?['name_ar']?.toString(),
      serviceNameEn: service?['name_en']?.toString(),
      companyId: _nullableInt(company?['id']),
      companyName: company?['name']?.toString(),
      companyNameAr: company?['name_ar']?.toString(),
      companyNameEn: company?['name_en']?.toString(),
      packageId: _nullableInt(package?['id']),
      packageName: package?['name']?.toString(),
      packageNameAr: package?['name_ar']?.toString(),
      packageNameEn: package?['name_en']?.toString(),
    );
  }
}

Map<String, dynamic>? _map(Object? value) =>
    value is Map<String, dynamic> ? value : null;
int _int(Object? value, {int fallback = 0}) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? fallback;
int? _nullableInt(Object? value) => value == null ? null : _int(value);
double _double(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
DateTime? _date(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
