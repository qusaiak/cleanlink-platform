import '../../domain/entities/payment_entities.dart';

class CreatePaymentIntentRequestModel {
  const CreatePaymentIntentRequestModel(this.orderId);
  final int orderId;

  Map<String, dynamic> toJson() => {'order_id': orderId};
}

class CreatePaymentIntentResponseModel {
  const CreatePaymentIntentResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  final int status;
  final String message;
  final PaymentIntentModel? data;

  factory CreatePaymentIntentResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => CreatePaymentIntentResponseModel(
    status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
    message: json['message']?.toString() ?? '',
    data: json['data'] is Map<String, dynamic>
        ? PaymentIntentModel.fromJson(json['data'] as Map<String, dynamic>)
        : null,
  );
}

class PaymentIntentModel {
  const PaymentIntentModel({
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

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      PaymentIntentModel(
        orderId: int.tryParse(json['order_id']?.toString() ?? '') ?? 0,
        amount: int.tryParse(json['amount']?.toString() ?? '') ?? 0,
        currency: json['currency']?.toString() ?? '',
        paymentIntentId: json['payment_intent_id']?.toString() ?? '',
        clientSecret: json['client_secret']?.toString() ?? '',
      );

  PaymentIntentEntity toEntity() => PaymentIntentEntity(
    orderId: orderId,
    amount: amount,
    currency: currency,
    paymentIntentId: paymentIntentId,
    clientSecret: clientSecret,
  );
}
