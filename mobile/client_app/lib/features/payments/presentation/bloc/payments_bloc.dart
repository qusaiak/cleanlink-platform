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
    this.backgroundPollAttempts = 8,
    this.backgroundPollDelay = const Duration(seconds: 2),
    this.statusRequestTimeout = const Duration(seconds: 8),
  }) : super(const PaymentsState()) {
    on<PayForOrder>(_payForOrder);
    on<_RecheckPaymentStatus>(_recheckPaymentStatus);
    on<ResetPaymentState>((_, emit) {
      _paymentSession++;
      emit(const PaymentsState());
    });
  }

  final CreatePaymentIntentUseCase createPaymentIntent;
  final StripePaymentService stripePaymentService;
  final ShowOrderUseCase showOrder;
  final int pollAttempts;
  final Duration pollDelay;
  final int backgroundPollAttempts;
  final Duration backgroundPollDelay;
  final Duration statusRequestTimeout;
  int _paymentSession = 0;

  Future<void> _payForOrder(
    PayForOrder event,
    Emitter<PaymentsState> emit,
  ) async {
    if (state.isBusy) return;
    final session = ++_paymentSession;
    var paymentSheetCompleted = false;
    emit(
      PaymentsState(stage: PaymentStage.creatingIntent, orderId: event.orderId),
    );
    try {
      final intent = await createPaymentIntent(orderId: event.orderId);
      emit(
        PaymentsState(
          stage: PaymentStage.preparingSheet,
          orderId: event.orderId,
        ),
      );
      await stripePaymentService.initPaymentSheet(
        clientSecret: intent.clientSecret,
        darkMode: event.darkMode,
      );
      emit(
        PaymentsState(
          stage: PaymentStage.presentingSheet,
          orderId: event.orderId,
        ),
      );
      await stripePaymentService.presentPaymentSheet();
      paymentSheetCompleted = true;
      emit(
        PaymentsState(
          stage: PaymentStage.awaitingBackend,
          orderId: event.orderId,
        ),
      );
      final order = await _waitForBackend(event.orderId);
      if (order.paymentStatusNormalized == 'failed') {
        emit(
          PaymentsState(
            stage: PaymentStage.failed,
            order: order,
            orderId: event.orderId,
          ),
        );
      } else if (!order.isPaymentConfirmed) {
        emit(
          PaymentsState(
            stage: PaymentStage.pendingConfirmation,
            order: order,
            orderId: event.orderId,
          ),
        );
        _schedulePaymentStatusRecheck(
          orderId: event.orderId,
          session: session,
          attemptsRemaining: backgroundPollAttempts,
        );
      } else {
        emit(
          PaymentsState(
            stage: PaymentStage.succeeded,
            order: order,
            orderId: event.orderId,
          ),
        );
      }
    } on StripeException catch (error) {
      if (error.error.code == FailureCode.Canceled) {
        // Cancellation must clear the loading state immediately. Refreshing the
        // order is handled by the destination screen and must not block the UI.
        emit(
          PaymentsState(stage: PaymentStage.cancelled, orderId: event.orderId),
        );
      } else {
        emit(
          PaymentsState(
            stage: PaymentStage.failed,
            errorMessage: error.error.localizedMessage ?? error.error.message,
            orderId: event.orderId,
          ),
        );
      }
    } catch (error) {
      if (paymentSheetCompleted) {
        // Stripe returned successfully, but Laravel could not be checked yet.
        // Never claim success until the authoritative backend confirms it.
        emit(
          PaymentsState(
            stage: PaymentStage.pendingConfirmation,
            errorMessage: error is Failure ? error.message : error.toString(),
            orderId: event.orderId,
          ),
        );
        _schedulePaymentStatusRecheck(
          orderId: event.orderId,
          session: session,
          attemptsRemaining: backgroundPollAttempts,
        );
        return;
      }
      emit(
        PaymentsState(
          stage: PaymentStage.failed,
          errorMessage: error is Failure ? error.message : error.toString(),
          orderId: event.orderId,
        ),
      );
    }
  }

  Future<OrderEntity> _waitForBackend(int orderId) async {
    late OrderEntity order;
    for (var attempt = 0; attempt < pollAttempts; attempt++) {
      if (attempt > 0) await Future<void>.delayed(pollDelay);
      order = await _showOrderWithTimeout(orderId);
      if (!order.isPaymentPending) return order;
    }
    return order;
  }

  Future<OrderEntity> _showOrderWithTimeout(int orderId) =>
      showOrder(orderId).timeout(statusRequestTimeout);

  void _schedulePaymentStatusRecheck({
    required int orderId,
    required int session,
    required int attemptsRemaining,
  }) {
    if (attemptsRemaining <= 0) return;
    Future<void>.delayed(backgroundPollDelay, () {
      if (isClosed || session != _paymentSession) return;
      add(
        _RecheckPaymentStatus(
          orderId: orderId,
          session: session,
          attemptsRemaining: attemptsRemaining,
        ),
      );
    });
  }

  Future<void> _recheckPaymentStatus(
    _RecheckPaymentStatus event,
    Emitter<PaymentsState> emit,
  ) async {
    if (event.session != _paymentSession ||
        state.stage != PaymentStage.pendingConfirmation ||
        state.orderId != event.orderId) {
      return;
    }

    try {
      final order = await _showOrderWithTimeout(event.orderId);
      if (event.session != _paymentSession) return;
      if (order.paymentStatusNormalized == 'failed') {
        emit(
          PaymentsState(
            stage: PaymentStage.failed,
            order: order,
            orderId: event.orderId,
          ),
        );
        return;
      }
      if (order.isPaymentConfirmed) {
        emit(
          PaymentsState(
            stage: PaymentStage.succeeded,
            order: order,
            orderId: event.orderId,
          ),
        );
        return;
      }
    } catch (_) {
      // A transient refresh failure must not become a fake payment failure.
    }

    _schedulePaymentStatusRecheck(
      orderId: event.orderId,
      session: event.session,
      attemptsRemaining: event.attemptsRemaining - 1,
    );
  }
}
