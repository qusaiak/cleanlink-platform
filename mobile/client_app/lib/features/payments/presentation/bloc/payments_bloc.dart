import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/payment/stripe_payment_service.dart';
import '../../domain/usecases/create_payment_intent_usecase.dart';
import '../../../bookings/domain/entities/booking_entity.dart';
import '../../../bookings/domain/usecases/show_order_usecase.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc(
    this.createPaymentIntent,
    this.stripePaymentService,
    this.showOrder, {
    this.pollAttempts = 3,
    this.pollDelay = const Duration(seconds: 1),
  }) : super(const PaymentsState()) {
    on<PayForOrder>(_payForOrder);
    on<ResetPaymentState>((_, emit) => emit(const PaymentsState()));
  }

  final CreatePaymentIntentUseCase createPaymentIntent;
  final StripePaymentService stripePaymentService;
  final ShowOrderUseCase showOrder;
  final int pollAttempts;
  final Duration pollDelay;

  Future<void> _payForOrder(
    PayForOrder event,
    Emitter<PaymentsState> emit,
  ) async {
    if (state.isBusy) return;
    emit(const PaymentsState(stage: PaymentStage.creatingIntent));
    try {
      final intent = await createPaymentIntent(orderId: event.orderId);
      emit(const PaymentsState(stage: PaymentStage.preparingSheet));
      await stripePaymentService.initPaymentSheet(
        clientSecret: intent.clientSecret,
        darkMode: event.darkMode,
      );
      emit(const PaymentsState(stage: PaymentStage.presentingSheet));
      await stripePaymentService.presentPaymentSheet();
      emit(const PaymentsState(stage: PaymentStage.awaitingBackend));
      final order = await _waitForBackend(event.orderId);
      if (order.paymentStatusNormalized == 'failed') {
        emit(PaymentsState(stage: PaymentStage.failed, order: order));
      } else if (!order.isPaymentConfirmed) {
        emit(
          PaymentsState(stage: PaymentStage.pendingConfirmation, order: order),
        );
      } else {
        emit(PaymentsState(stage: PaymentStage.succeeded, order: order));
      }
    } on StripeException catch (error) {
      final order = await _refreshSafely(event.orderId);
      if (error.error.code == FailureCode.Canceled) {
        emit(PaymentsState(stage: PaymentStage.cancelled, order: order));
      } else {
        emit(
          PaymentsState(
            stage: PaymentStage.failed,
            errorMessage: error.error.localizedMessage ?? error.error.message,
            order: order,
          ),
        );
      }
    } catch (error) {
      final order = await _refreshSafely(event.orderId);
      emit(
        PaymentsState(
          stage: PaymentStage.failed,
          errorMessage: error is Failure ? error.message : error.toString(),
          order: order,
        ),
      );
    }
  }

  Future<OrderEntity> _waitForBackend(int orderId) async {
    late OrderEntity order;
    for (var attempt = 0; attempt < pollAttempts; attempt++) {
      if (attempt > 0) await Future<void>.delayed(pollDelay);
      order = await showOrder(orderId);
      if (!order.isPaymentPending) return order;
    }
    return order;
  }

  Future<OrderEntity?> _refreshSafely(int orderId) async {
    try {
      return await showOrder(orderId);
    } catch (_) {
      return null;
    }
  }
}
