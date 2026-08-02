part of 'bookings_bloc.dart';

enum BookingTab { all, pending, assigned, inProcess, completed, canceled }

class BookingsState extends Equatable {
  final List<OrderEntity> orders;
  final OrderEntity? selectedOrder;

  final bool isLoadingOrders;
  final bool isLoadingMoreOrders;
  final bool isRefreshingOrders;
  final bool hasLoadedOrders;

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  final String? ordersErrorMessage;
  final String? loadMoreOrdersError;

  final bool isBookingOrder;
  final bool isLoadingOrderDetails;
  final bool isCancelingOrder;
  final bool isLoadingSlots;

  final String? errorMessage;
  final String? successMessage;

  final bool bookingSuccess;
  final bool cancelSuccess;

  final BookingTab selectedTab;

  final List<AvailableDayEntity> availableDays;
  final AvailableDayEntity? selectedDay;
  final String? selectedTime;

  const BookingsState({
    required this.orders,
    this.selectedOrder,
    required this.isLoadingOrders,
    required this.isLoadingMoreOrders,
    required this.isRefreshingOrders,
    required this.hasLoadedOrders,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
    this.ordersErrorMessage,
    this.loadMoreOrdersError,
    required this.isBookingOrder,
    required this.isLoadingOrderDetails,
    required this.isCancelingOrder,
    required this.isLoadingSlots,
    this.errorMessage,
    this.successMessage,
    required this.bookingSuccess,
    required this.cancelSuccess,
    required this.selectedTab,
    required this.availableDays,
    this.selectedDay,
    this.selectedTime,
  });

  factory BookingsState.initial() => const BookingsState(
    orders: [],
    isLoadingOrders: false,
    isLoadingMoreOrders: false,
    isRefreshingOrders: false,
    hasLoadedOrders: false,
    currentPage: 0,
    perPage: PaginationConstants.ordersPageSize,
    total: 0,
    lastPage: 1,
    hasMorePages: true,
    isBookingOrder: false,
    isLoadingOrderDetails: false,
    isCancelingOrder: false,
    isLoadingSlots: false,
    bookingSuccess: false,
    cancelSuccess: false,
    selectedTab: BookingTab.all,
    availableDays: [],
  );

  bool get loading => isLoadingSlots;

  List<OrderEntity> get bookings => orders;

  BookingsState copyWith({
    List<OrderEntity>? orders,
    OrderEntity? selectedOrder,
    bool clearSelectedOrder = false,

    bool? isLoadingOrders,
    bool? isLoadingMoreOrders,
    bool? isRefreshingOrders,
    bool? hasLoadedOrders,

    int? currentPage,
    int? perPage,
    int? total,
    int? lastPage,
    bool? hasMorePages,

    String? ordersErrorMessage,
    bool clearOrdersErrorMessage = false,
    String? loadMoreOrdersError,
    bool clearLoadMoreOrdersError = false,

    bool? isBookingOrder,
    bool? isLoadingOrderDetails,
    bool? isCancelingOrder,
    bool? isLoadingSlots,

    String? errorMessage,
    bool clearError = false,

    String? successMessage,
    bool clearSuccessMessage = false,

    bool? bookingSuccess,
    bool? cancelSuccess,

    BookingTab? selectedTab,

    List<AvailableDayEntity>? availableDays,
    AvailableDayEntity? selectedDay,
    bool clearSelectedDay = false,

    String? selectedTime,
    bool clearSelectedTime = false,
  }) {
    return BookingsState(
      orders: orders ?? this.orders,
      selectedOrder: clearSelectedOrder
          ? null
          : selectedOrder ?? this.selectedOrder,

      isLoadingOrders: isLoadingOrders ?? this.isLoadingOrders,
      isLoadingMoreOrders: isLoadingMoreOrders ?? this.isLoadingMoreOrders,
      isRefreshingOrders: isRefreshingOrders ?? this.isRefreshingOrders,
      hasLoadedOrders: hasLoadedOrders ?? this.hasLoadedOrders,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      lastPage: lastPage ?? this.lastPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      ordersErrorMessage: clearOrdersErrorMessage
          ? null
          : ordersErrorMessage ?? this.ordersErrorMessage,
      loadMoreOrdersError: clearLoadMoreOrdersError
          ? null
          : loadMoreOrdersError ?? this.loadMoreOrdersError,

      isBookingOrder: isBookingOrder ?? this.isBookingOrder,
      isLoadingOrderDetails:
          isLoadingOrderDetails ?? this.isLoadingOrderDetails,
      isCancelingOrder: isCancelingOrder ?? this.isCancelingOrder,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,

      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
      cancelSuccess: cancelSuccess ?? this.cancelSuccess,

      selectedTab: selectedTab ?? this.selectedTab,

      availableDays: availableDays ?? this.availableDays,
      selectedDay: clearSelectedDay ? null : selectedDay ?? this.selectedDay,
      selectedTime: clearSelectedTime
          ? null
          : selectedTime ?? this.selectedTime,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    selectedOrder,
    isLoadingOrders,
    isLoadingMoreOrders,
    isRefreshingOrders,
    hasLoadedOrders,
    currentPage,
    perPage,
    total,
    lastPage,
    hasMorePages,
    ordersErrorMessage,
    loadMoreOrdersError,
    isBookingOrder,
    isLoadingOrderDetails,
    isCancelingOrder,
    isLoadingSlots,
    errorMessage,
    successMessage,
    bookingSuccess,
    cancelSuccess,
    selectedTab,
    availableDays,
    selectedDay,
    selectedTime,
  ];
}
