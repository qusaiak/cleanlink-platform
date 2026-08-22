part of 'payments_bloc.dart';

enum PaymentStage {
  idle,
  creatingIntent,
  preparingSheet,
  presentingSheet,
  awaitingBackend,
  succeeded,
  pendingConfirmation,
  cancelled,
  failed,
}

class PaymentsState extends Equatable {
  const PaymentsState({
    this.stage = PaymentStage.idle,
    this.errorMessage,
    this.order,
    this.orderId,
  });
  final PaymentStage stage;
  final String? errorMessage;
  final OrderEntity? order;
  final int? orderId;

  bool get isBusy =>
      stage == PaymentStage.creatingIntent ||
      stage == PaymentStage.preparingSheet ||
      stage == PaymentStage.presentingSheet ||
      stage == PaymentStage.awaitingBackend;

  @override
  List<Object?> get props => [stage, errorMessage, order, orderId];
}
