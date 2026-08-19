import '../entities/payment_entities.dart';

abstract class PaymentsRepository {
  Future<PaymentIntentEntity> createPaymentIntent({required int orderId});

  Future<ClientPaymentsPage> getClientPayments({
    required int page,
    required int perPage,
    String? status,
    String? paymentMethod,
  });

  Future<ClientPaymentEntity> getClientPayment(int paymentId);
}
