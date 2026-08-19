part of 'payment_history_bloc.dart';

class PaymentHistoryState extends Equatable {
  const PaymentHistoryState({
    this.payments = const [],
    this.currentPage = 0,
    this.lastPage = 1,
    this.total = 0,
    this.statusFilter,
    this.paymentMethodFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.selectedPayment,
    this.isLoadingDetails = false,
    this.detailsError,
  });

  final List<ClientPaymentEntity> payments;
  final int currentPage;
  final int lastPage;
  final int total;
  final String? statusFilter;
  final String? paymentMethodFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final ClientPaymentEntity? selectedPayment;
  final bool isLoadingDetails;
  final String? detailsError;

  bool get hasMore => currentPage < lastPage;

  PaymentHistoryState copyWith({
    List<ClientPaymentEntity>? payments,
    int? currentPage,
    int? lastPage,
    int? total,
    String? statusFilter,
    bool clearStatusFilter = false,
    String? paymentMethodFilter,
    bool clearPaymentMethodFilter = false,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    ClientPaymentEntity? selectedPayment,
    bool? isLoadingDetails,
    String? detailsError,
    bool clearDetailsError = false,
  }) => PaymentHistoryState(
    payments: payments ?? this.payments,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    total: total ?? this.total,
    statusFilter: clearStatusFilter ? null : statusFilter ?? this.statusFilter,
    paymentMethodFilter: clearPaymentMethodFilter
        ? null
        : paymentMethodFilter ?? this.paymentMethodFilter,
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    selectedPayment: selectedPayment ?? this.selectedPayment,
    isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
    detailsError: clearDetailsError ? null : detailsError ?? this.detailsError,
  );

  @override
  List<Object?> get props => [
    payments,
    currentPage,
    lastPage,
    total,
    statusFilter,
    paymentMethodFilter,
    isLoading,
    isLoadingMore,
    errorMessage,
    selectedPayment,
    isLoadingDetails,
    detailsError,
  ];
}
