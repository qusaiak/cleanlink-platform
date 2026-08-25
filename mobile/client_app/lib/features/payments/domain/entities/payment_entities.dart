import 'package:equatable/equatable.dart';

enum PaymentMethodType {
  cash('cash'),
  card('card');

  const PaymentMethodType(this.apiValue);
  final String apiValue;
}

enum PaymentStatusType {
  pending('pending'),
  held('held'),
  captured('captured'),
  refunded('refunded'),
  failed('failed');

  const PaymentStatusType(this.apiValue);
  final String apiValue;
}

PaymentMethodType paymentMethodFromApi(String? value) =>
    PaymentMethodType.values.firstWhere(
      (method) => method.apiValue == value?.trim().toLowerCase(),
      orElse: () => throw FormatException(
        'Unsupported payment method: ${value ?? 'null'}',
      ),
    );

PaymentStatusType paymentStatusFromApi(String? value) =>
    PaymentStatusType.values.firstWhere(
      (status) => status.apiValue == value?.trim().toLowerCase(),
      orElse: () => throw FormatException(
        'Unsupported payment status: ${value ?? 'null'}',
      ),
    );

PaymentStatusType? tryPaymentStatusFromApi(String? value) {
  final normalized = value?.trim().toLowerCase();
  for (final status in PaymentStatusType.values) {
    if (status.apiValue == normalized) return status;
  }
  return null;
}

class PaymentIntentEntity extends Equatable {
  const PaymentIntentEntity({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentIntentId,
    required this.clientSecret,
  });

  final int orderId;
  final int amount;
  final String currency;
  final String paymentIntentId;
  final String clientSecret;

  @override
  List<Object?> get props => [orderId, amount, currency, paymentIntentId];
}

class ClientPaymentEntity extends Equatable {
  const ClientPaymentEntity({
    required this.id,
    required this.orderId,
    required this.orderStatus,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    this.bookingDate,
    this.paidAt,
    this.serviceId,
    this.serviceName,
    this.serviceNameAr,
    this.serviceNameEn,
    this.companyId,
    this.companyName,
    this.companyNameAr,
    this.companyNameEn,
    this.packageId,
    this.packageName,
    this.packageNameAr,
    this.packageNameEn,
    this.paymentIntentId,
  });

  final int id;
  final int orderId;
  final String orderStatus;
  final double amount;
  final String currency;
  final PaymentMethodType paymentMethod;
  final PaymentStatusType paymentStatus;
  final DateTime? createdAt;
  final DateTime? bookingDate;
  final DateTime? paidAt;
  final int? serviceId;
  final String? serviceName;
  final String? serviceNameAr;
  final String? serviceNameEn;
  final int? companyId;
  final String? companyName;
  final String? companyNameAr;
  final String? companyNameEn;
  final int? packageId;
  final String? packageName;
  final String? packageNameAr;
  final String? packageNameEn;
  final String? paymentIntentId;

  bool get isCard => paymentMethod == PaymentMethodType.card;
  bool get isCash => paymentMethod == PaymentMethodType.cash;

  @override
  List<Object?> get props => [
    id,
    orderId,
    orderStatus,
    amount,
    paymentMethod,
    paymentStatus,
    createdAt,
    serviceName,
    serviceNameAr,
    serviceNameEn,
    packageName,
    packageNameAr,
    packageNameEn,
    companyName,
    companyNameAr,
    companyNameEn,
  ];
}

class ClientPaymentsPage extends Equatable {
  const ClientPaymentsPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final List<ClientPaymentEntity> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [items, currentPage, lastPage, perPage, total];
}
