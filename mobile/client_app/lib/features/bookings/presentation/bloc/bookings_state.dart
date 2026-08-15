part of 'bookings_bloc.dart';

enum BookingTab {
  all,
  pending,
  assigned,
  onTheWay,
  inProcess,
  completed,
  canceled,
}

class BookingsState extends Equatable {
  final List<OrderEntity> orders;
  final OrderEntity? selectedOrder;

  final bool isLoadingOrders;
  final bool isRefreshingOrders;
  final bool hasLoadedOrders;

  final String? ordersErrorMessage;

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
  final SelectedMapLocation? selectedLocation;
  final Failure? slotsFailure;
  final PackageEntity? package;
  final List<AttributeEntity> serviceAttributes;
  final Map<int, int> openPackageAttributeQuantities;
  final OpenPackageQuote? openPackageQuote;
  final bool isCheckingOpenPackagePrice;

  const BookingsState({
    required this.orders,
    this.selectedOrder,
    required this.isLoadingOrders,
    required this.isRefreshingOrders,
    required this.hasLoadedOrders,
    this.ordersErrorMessage,
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
    this.selectedLocation,
    this.slotsFailure,
    this.package,
    this.serviceAttributes = const [],
    this.openPackageAttributeQuantities = const {},
    this.openPackageQuote,
    this.isCheckingOpenPackagePrice = false,
  });

  factory BookingsState.initial() => const BookingsState(
    orders: [],
    isLoadingOrders: false,
    isRefreshingOrders: false,
    hasLoadedOrders: false,
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

  bool get isOpenPackageConfigurationChecked => openPackageQuote != null;

  List<SelectedOpenPackageAttribute> get selectedOpenPackageAttributes =>
      openPackageAttributeQuantities.entries
          .where((entry) => entry.value > 0)
          .map(
            (entry) =>
                SelectedOpenPackageAttribute(id: entry.key, qty: entry.value),
          )
          .toList(growable: false);

  BookingsState copyWith({
    List<OrderEntity>? orders,
    OrderEntity? selectedOrder,
    bool clearSelectedOrder = false,

    bool? isLoadingOrders,
    bool? isRefreshingOrders,
    bool? hasLoadedOrders,

    String? ordersErrorMessage,
    bool clearOrdersErrorMessage = false,

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
    SelectedMapLocation? selectedLocation,
    bool clearSelectedLocation = false,
    Failure? slotsFailure,
    bool clearSlotsFailure = false,
    PackageEntity? package,
    bool clearPackage = false,
    List<AttributeEntity>? serviceAttributes,
    Map<int, int>? openPackageAttributeQuantities,
    OpenPackageQuote? openPackageQuote,
    bool clearOpenPackageQuote = false,
    bool? isCheckingOpenPackagePrice,
  }) {
    return BookingsState(
      orders: orders ?? this.orders,
      selectedOrder: clearSelectedOrder
          ? null
          : selectedOrder ?? this.selectedOrder,

      isLoadingOrders: isLoadingOrders ?? this.isLoadingOrders,
      isRefreshingOrders: isRefreshingOrders ?? this.isRefreshingOrders,
      hasLoadedOrders: hasLoadedOrders ?? this.hasLoadedOrders,
      ordersErrorMessage: clearOrdersErrorMessage
          ? null
          : ordersErrorMessage ?? this.ordersErrorMessage,

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
      selectedLocation: clearSelectedLocation
          ? null
          : selectedLocation ?? this.selectedLocation,
      slotsFailure: clearSlotsFailure
          ? null
          : slotsFailure ?? this.slotsFailure,
      package: clearPackage ? null : package ?? this.package,
      serviceAttributes: serviceAttributes ?? this.serviceAttributes,
      openPackageAttributeQuantities:
          openPackageAttributeQuantities ?? this.openPackageAttributeQuantities,
      openPackageQuote: clearOpenPackageQuote
          ? null
          : openPackageQuote ?? this.openPackageQuote,
      isCheckingOpenPackagePrice:
          isCheckingOpenPackagePrice ?? this.isCheckingOpenPackagePrice,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    selectedOrder,
    isLoadingOrders,
    isRefreshingOrders,
    hasLoadedOrders,
    ordersErrorMessage,
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
    selectedLocation,
    slotsFailure,
    package,
    serviceAttributes,
    openPackageAttributeQuantities,
    openPackageQuote,
    isCheckingOpenPackagePrice,
  ];
}
