import '../entities/payment_entities.dart';
import '../repositories/payments_repository.dart';

class CreatePaymentIntentUseCase {
  const CreatePaymentIntentUseCase(this.repository);
  final PaymentsRepository repository;

  Future<PaymentIntentEntity> call({required int orderId}) =>
      repository.createPaymentIntent(orderId: orderId);
}
