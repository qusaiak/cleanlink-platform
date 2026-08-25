import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/available_day_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/book_order_usecase.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import '../../domain/usecases/get_available_slots_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../../domain/usecases/show_order_usecase.dart';
import '../../../payments/domain/entities/payment_entities.dart';
import '../../domain/usecases/open_package_usecases.dart';
import '../../domain/entities/open_package_entities.dart';
import '../../../services/domain/entities/attribute_entity.dart';
import '../../../services/domain/entities/package_entity.dart';
import '../../../locations/domain/entities/selected_map_location.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  int _slotRequestId = 0;
  int _quoteRequestId = 0;
  final GetAvailableSlotsUseCase getAvailableSlotsUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final BookOrderUseCase bookOrderUseCase;
  final ShowOrderUseCase showOrderUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  final CheckOpenPackagePriceUseCase? checkOpenPackagePriceUseCase;
  final GetOpenPackageAvailableSlotsUseCase?
  getOpenPackageAvailableSlotsUseCase;
  BookingsBloc(
    this.getAvailableSlotsUseCase,
    this.getOrdersUseCase,
    this.bookOrderUseCase,
    this.showOrderUseCase,
    this.cancelOrderUseCase, [
    this.checkOpenPackagePriceUseCase,
    this.getOpenPackageAvailableSlotsUseCase,
  ]) : super(BookingsState.initial()) {
    on<GetOrdersEvent>(_getOrders);
    on<BookOrderEvent>(_bookOrder);
    on<ShowOrderEvent>(_showOrder);
    on<CancelOrderEvent>(_cancelOrder);
    on<ResetBookingStateEvent>((_, emit) {
      _slotRequestId++;
      emit(
        state.copyWith(
          clearError: true,
          clearSuccessMessage: true,
          bookingSuccess: false,
          cancelSuccess: false,
          availableDays: const [],
          clearSelectedDay: true,
          clearSelectedTime: true,
          clearSelectedLocation: true,
          clearSlotsFailure: true,
          clearPackage: true,
          serviceAttributes: const [],
          openPackageAttributeQuantities: const {},
          clearOpenPackageQuote: true,
          isCheckingOpenPackagePrice: false,
        ),
      );
    });
    on<LoadAvailableSlots>(_loadAvailableSlots);
    on<ConfigureBookingPackage>(_configureBookingPackage);
    on<UpdateOpenPackageAttributeQty>(_updateOpenPackageAttributeQty);
    on<CheckOpenPackagePrice>(_checkOpenPackagePrice);
    on<SelectDate>(
      (event, emit) =>
          emit(state.copyWith(selectedDay: event.day, clearSelectedTime: true)),
    );
    on<SelectTime>(
      (event, emit) => emit(state.copyWith(selectedTime: event.time)),
    );
    on<SelectBookingLocation>((event, emit) {
      _slotRequestId++;
      emit(
        state.copyWith(
          selectedLocation: event.location,
          availableDays: const [],
          clearSelectedDay: true,
          clearSelectedTime: true,
          clearSlotsFailure: true,
        ),
      );
      if (!(state.package?.isOpenPackage ?? false) ||
          state.isOpenPackageConfigurationChecked) {
        add(
          LoadAvailableSlots(
            packageId: event.packageId,
            latitude: event.location.latitude,
            longitude: event.location.longitude,
          ),
        );
      }
    });
    on<ClearBookingLocation>((_, emit) {
      _slotRequestId++;
      emit(
        state.copyWith(
          clearSelectedLocation: true,
          availableDays: const [],
          clearSelectedDay: true,
          clearSelectedTime: true,
          clearSlotsFailure: true,
          isLoadingSlots: false,
        ),
      );
    });
    on<ChangeTab>(
      (event, emit) => emit(state.copyWith(selectedTab: event.tab)),
    );
  }
  String _message(Object error) => error is Failure
      ? error.message
      : error.toString().replaceFirst('Exception: ', '');

  Future<void> _getOrders(
    GetOrdersEvent event,
    Emitter<BookingsState> emit,
  ) async {
    if (state.isLoadingOrders) {
      event.completer?.complete();
      return;
    }

    emit(
      state.copyWith(
        isLoadingOrders: true,
        isRefreshingOrders: event.isRefresh,
        hasLoadedOrders: false,
        orders: const [],
        clearOrdersErrorMessage: true,
        clearError: true,
      ),
    );

    try {
      final result = await getOrdersUseCase();

      emit(
        state.copyWith(
          orders: result,
          isLoadingOrders: false,
          isRefreshingOrders: false,
          hasLoadedOrders: true,
        ),
      );
    } catch (e) {
      final message = _message(e);
      emit(
        state.copyWith(
          isLoadingOrders: false,
          isRefreshingOrders: false,
          hasLoadedOrders: true,
          ordersErrorMessage: message,
        ),
      );
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _bookOrder(
    BookOrderEvent event,
    Emitter<BookingsState> emit,
  ) async {
    emit(
      state.copyWith(
        isBookingOrder: true,
        bookingSuccess: false,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );
    try {
      final result = await bookOrderUseCase(
        packageId: event.packageId,
        location: event.location,
        latitude: event.latitude,
        longitude: event.longitude,
        startTime: event.startTime,
        note: event.note,
        isOpenPackage: state.package?.isOpenPackage ?? false,
        attributes: state.selectedOpenPackageAttributes,
        paymentMethod: event.paymentMethod,
      );
      emit(
        state.copyWith(
          isBookingOrder: false,
          bookingSuccess: true,
          successMessage: result.message,
          orders: [
            result.order,
            ...state.orders.where((item) => item.id != result.order.id),
          ],
          selectedOrder: result.order,
        ),
      );
    } catch (e) {
      final isConflict = e is BookingConflictFailure;
      final location = state.selectedLocation;
      final package = state.package;
      emit(
        state.copyWith(
          isBookingOrder: false,
          errorMessage: isConflict ? 'booking_conflict' : _message(e),
          clearSelectedTime: isConflict,
        ),
      );
      if (isConflict && location != null && package != null) {
        add(
          LoadAvailableSlots(
            packageId: package.id,
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        );
      }
    }
  }

  Future<void> _showOrder(
    ShowOrderEvent event,
    Emitter<BookingsState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoadingOrderDetails: true,
        clearError: true,
        clearSelectedOrder: true,
      ),
    );
    try {
      emit(
        state.copyWith(
          selectedOrder: await showOrderUseCase(event.orderId),
          isLoadingOrderDetails: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoadingOrderDetails: false, errorMessage: _message(e)),
      );
    }
  }

  Future<void> _cancelOrder(
    CancelOrderEvent event,
    Emitter<BookingsState> emit,
  ) async {
    emit(
      state.copyWith(
        isCancelingOrder: true,
        cancelSuccess: false,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );
    try {
      final result = await cancelOrderUseCase(event.orderId);
      final canceled = result.order.status.isEmpty
          ? result.order.copyWith(status: 'canceled')
          : result.order;
      emit(
        state.copyWith(
          isCancelingOrder: false,
          cancelSuccess: true,
          successMessage: result.message,
          selectedOrder: canceled,
          orders: state.orders
              .map((item) => item.id == event.orderId ? canceled : item)
              .toList(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isCancelingOrder: false, errorMessage: _message(e)));
    }
  }

  Future<void> _loadAvailableSlots(
    LoadAvailableSlots event,
    Emitter<BookingsState> emit,
  ) async {
    final requestId = ++_slotRequestId;
    emit(
      state.copyWith(
        isLoadingSlots: true,
        clearError: true,
        clearSlotsFailure: true,
        availableDays: const [],
        clearSelectedDay: true,
        clearSelectedTime: true,
      ),
    );

    try {
      final isOpen = state.package?.isOpenPackage ?? false;
      final days = isOpen && getOpenPackageAvailableSlotsUseCase != null
          ? await getOpenPackageAvailableSlotsUseCase!(
              packageId: event.packageId,
              latitude: event.latitude,
              longitude: event.longitude,
              attributes: state.selectedOpenPackageAttributes,
            )
          : await getAvailableSlotsUseCase(
              packageId: event.packageId,
              latitude: event.latitude,
              longitude: event.longitude,
            );
      if (requestId != _slotRequestId) return;

      final bookableDays = days
          .map(
            (day) => AvailableDayEntity(
              date: day.date,
              slots: day.slots
                  .map((slot) => slot.trim())
                  .where((slot) => slot.isNotEmpty)
                  .toSet()
                  .toList(growable: false),
            ),
          )
          .where((day) => day.hasAvailableSlots)
          .toList(growable: false);

      AvailableDayEntity? first;
      if (bookableDays.isNotEmpty) {
        first = bookableDays.first;
      }

      emit(
        state.copyWith(
          isLoadingSlots: false,
          availableDays: bookableDays,
          selectedDay: first,
          clearSelectedTime: true,
        ),
      );
    } catch (e) {
      if (requestId != _slotRequestId) return;
      emit(
        state.copyWith(
          isLoadingSlots: false,
          slotsFailure: e is Failure
              ? e
              : ServerFailure(_message(e), 'UNKNOWN'),
        ),
      );
    }
  }

  void _configureBookingPackage(
    ConfigureBookingPackage event,
    Emitter<BookingsState> emit,
  ) {
    _quoteRequestId++;
    _slotRequestId++;
    final quantities = event.package.isOpenPackage
        ? {
            for (final attribute in event.attributes)
              attribute.id:
                  (event.initialAttributeQuantities[attribute.id] ?? 0).clamp(
                    0,
                    999,
                  ),
          }
        : <int, int>{};
    emit(
      state.copyWith(
        package: event.package,
        serviceAttributes: event.package.isOpenPackage
            ? event.attributes
            : const [],
        openPackageAttributeQuantities: quantities,
        clearOpenPackageQuote: true,
        isCheckingOpenPackagePrice: false,
        availableDays: const [],
        clearSelectedDay: true,
        clearSelectedTime: true,
        clearSlotsFailure: true,
      ),
    );
  }

  void _updateOpenPackageAttributeQty(
    UpdateOpenPackageAttributeQty event,
    Emitter<BookingsState> emit,
  ) {
    final package = state.package;
    if (package == null || !package.isOpenPackage) return;
    final quantities = Map<int, int>.from(state.openPackageAttributeQuantities);
    final attribute = state.serviceAttributes
        .where((item) => item.id == event.attributeId)
        .firstOrNull;
    quantities[event.attributeId] = attribute?.isBoolean == true
        ? (event.qty > 0 ? 1 : 0)
        : (event.qty < 0 ? 0 : event.qty);
    _quoteRequestId++;
    _slotRequestId++;
    emit(
      state.copyWith(
        openPackageAttributeQuantities: quantities,
        clearOpenPackageQuote: true,
        isCheckingOpenPackagePrice: false,
        availableDays: const [],
        clearSelectedDay: true,
        clearSelectedTime: true,
        clearSlotsFailure: true,
      ),
    );
  }

  Future<void> _checkOpenPackagePrice(
    CheckOpenPackagePrice event,
    Emitter<BookingsState> emit,
  ) async {
    final useCase = checkOpenPackagePriceUseCase;
    if (useCase == null || state.package?.id != event.packageId) {
      emit(state.copyWith(isCheckingOpenPackagePrice: false));
      return;
    }
    // if (!state.areAllOpenPackageAttributesConfigured) {
    //   emit(
    //     state.copyWith(
    //       isCheckingOpenPackagePrice: false,
    //       errorMessage: 'configure_all_open_package_attributes',
    //     ),
    //   );
    //   return;
    // }
    final requestId = ++_quoteRequestId;
    emit(
      state.copyWith(
        isCheckingOpenPackagePrice: true,
        clearOpenPackageQuote: true,
        clearError: true,
      ),
    );
    try {
      final quote = await useCase(
        packageId: event.packageId,
        attributes: state.selectedOpenPackageAttributes,
      );
      if (requestId != _quoteRequestId) return;
      emit(
        state.copyWith(
          openPackageQuote: quote,
          isCheckingOpenPackagePrice: false,
          clearError: true,
        ),
      );
      final location = state.selectedLocation;
      if (location != null) {
        add(
          LoadAvailableSlots(
            packageId: event.packageId,
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        );
      }
    } catch (error) {
      if (requestId != _quoteRequestId) return;
      emit(
        state.copyWith(
          isCheckingOpenPackagePrice: false,
          errorMessage: _message(error),
        ),
      );
    }
  }
}
