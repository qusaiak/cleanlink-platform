part of 'payment_history_bloc.dart';

sealed class PaymentHistoryEvent extends Equatable {
  const PaymentHistoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadPaymentHistory extends PaymentHistoryEvent {
  const LoadPaymentHistory();
}

class LoadMorePayments extends PaymentHistoryEvent {
  const LoadMorePayments();
}

class ChangePaymentHistoryFilters extends PaymentHistoryEvent {
  const ChangePaymentHistoryFilters({this.status, this.paymentMethod});
  final String? status;
  final String? paymentMethod;

  @override
  List<Object?> get props => [status, paymentMethod];
}

class LoadPaymentDetails extends PaymentHistoryEvent {
  const LoadPaymentDetails(this.paymentId);
  final int paymentId;

  @override
  List<Object?> get props => [paymentId];
}
