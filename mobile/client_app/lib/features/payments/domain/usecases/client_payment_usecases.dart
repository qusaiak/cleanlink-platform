import '../entities/payment_entities.dart';
import '../repositories/payments_repository.dart';

class GetClientPaymentsUseCase {
  const GetClientPaymentsUseCase(this.repository);
  final PaymentsRepository repository;

  Future<ClientPaymentsPage> call({
    required int page,
    int perPage = 10,
    String? status,
    String? paymentMethod,
  }) => repository.getClientPayments(
    page: page,
    perPage: perPage,
    status: status,
    paymentMethod: paymentMethod,
  );
}

class GetClientPaymentUseCase {
  const GetClientPaymentUseCase(this.repository);
  final PaymentsRepository repository;

  Future<ClientPaymentEntity> call(int paymentId) =>
      repository.getClientPayment(paymentId);
}
