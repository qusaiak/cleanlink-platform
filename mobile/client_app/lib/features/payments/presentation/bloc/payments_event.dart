part of 'payments_bloc.dart';

sealed class PaymentsEvent extends Equatable {
  const PaymentsEvent();
  @override
  List<Object?> get props => [];
}

class PayForOrder extends PaymentsEvent {
  const PayForOrder({required this.orderId, required this.darkMode});
  final int orderId;
  final bool darkMode;

  @override
  List<Object?> get props => [orderId, darkMode];
}

class ResetPaymentState extends PaymentsEvent {
  const ResetPaymentState();
}
