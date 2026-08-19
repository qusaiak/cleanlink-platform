import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/payment_entities.dart';
import '../../domain/usecases/client_payment_usecases.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc(this.getPayments, this.getPayment)
    : super(const PaymentHistoryState()) {
    on<LoadPaymentHistory>(_load);
    on<LoadMorePayments>(_loadMore);
    on<ChangePaymentHistoryFilters>(_changeFilters);
    on<LoadPaymentDetails>(_loadDetails);
  }

  final GetClientPaymentsUseCase getPayments;
  final GetClientPaymentUseCase getPayment;

  Future<void> _load(
    LoadPaymentHistory event,
    Emitter<PaymentHistoryState> emit,
  ) => _fetchPage(emit, page: 1, replace: true);

  Future<void> _changeFilters(
    ChangePaymentHistoryFilters event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        statusFilter: event.status,
        paymentMethodFilter: event.paymentMethod,
        clearStatusFilter: event.status == null,
        clearPaymentMethodFilter: event.paymentMethod == null,
      ),
    );
    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _loadMore(
    LoadMorePayments event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    await _fetchPage(emit, page: state.currentPage + 1, replace: false);
  }

  Future<void> _fetchPage(
    Emitter<PaymentHistoryState> emit, {
    required int page,
    required bool replace,
  }) async {
    if (replace) {
      emit(
        state.copyWith(
          payments: const [],
          currentPage: 0,
          isLoading: true,
          clearError: true,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMore: true, clearError: true));
    }
    try {
      final result = await getPayments(
        page: page,
        status: state.statusFilter,
        paymentMethod: state.paymentMethodFilter,
      );
      emit(
        state.copyWith(
          payments: replace
              ? result.items
              : [...state.payments, ...result.items],
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
          isLoading: false,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: error is Failure ? error.message : error.toString(),
        ),
      );
    }
  }

  Future<void> _loadDetails(
    LoadPaymentDetails event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetails: true, clearDetailsError: true));
    try {
      final payment = await getPayment(event.paymentId);
      emit(
        state.copyWith(
          selectedPayment: payment,
          isLoadingDetails: false,
          clearDetailsError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingDetails: false,
          detailsError: error is Failure ? error.message : error.toString(),
        ),
      );
    }
  }
}
