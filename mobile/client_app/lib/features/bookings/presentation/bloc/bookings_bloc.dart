import 'dart:async';

import 'package:client_app/config/constants/pagination_constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/pagination/pagination_utils.dart';
import '../../domain/entities/available_day_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/book_order_usecase.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import '../../domain/usecases/get_available_slots_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../../domain/usecases/show_order_usecase.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetAvailableSlotsUseCase getAvailableSlotsUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final BookOrderUseCase bookOrderUseCase;
  final ShowOrderUseCase showOrderUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  BookingsBloc(
    this.getAvailableSlotsUseCase,
    this.getOrdersUseCase,
    this.bookOrderUseCase,
    this.showOrderUseCase,
    this.cancelOrderUseCase,
  ) : super(BookingsState.initial()) {
    on<GetOrdersEvent>(_getOrders);
    on<GetMoreOrdersEvent>(_getMoreOrders);
    on<BookOrderEvent>(_bookOrder);
    on<ShowOrderEvent>(_showOrder);
    on<CancelOrderEvent>(_cancelOrder);
    on<ResetBookingStateEvent>(
      (_, emit) => emit(
        state.copyWith(
          clearError: true,
          clearSuccessMessage: true,
          bookingSuccess: false,
          cancelSuccess: false,
        ),
      ),
    );
    on<LoadAvailableSlots>(_loadAvailableSlots);
    on<SelectDate>(
      (event, emit) =>
          emit(state.copyWith(selectedDay: event.day, clearSelectedTime: true)),
    );
    on<SelectTime>(
      (event, emit) => emit(state.copyWith(selectedTime: event.time)),
    );
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
    if (state.isLoadingOrders || state.isLoadingMoreOrders) {
      event.completer?.complete();
      return;
    }

    emit(
      state.copyWith(
        isLoadingOrders: true,
        isRefreshingOrders: event.isRefresh,
        isLoadingMoreOrders: false,
        hasLoadedOrders: false,
        orders: const [],
        currentPage: 0,
        perPage: PaginationConstants.ordersPageSize,
        total: 0,
        lastPage: 1,
        hasMorePages: true,
        clearOrdersErrorMessage: true,
        clearLoadMoreOrdersError: true,
        clearError: true,
      ),
    );

    try {
      final result = await getOrdersUseCase(
        page: 1,
        perPage: PaginationConstants.ordersPageSize,
      );

      emit(
        state.copyWith(
          orders: result.items,
          isLoadingOrders: false,
          isRefreshingOrders: false,
          hasLoadedOrders: true,
          currentPage: result.pagination.currentPage,
          perPage: result.pagination.perPage,
          total: result.pagination.total,
          lastPage: result.pagination.lastPage,
          hasMorePages: result.pagination.hasMorePages,
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

  Future<void> _getMoreOrders(
    GetMoreOrdersEvent event,
    Emitter<BookingsState> emit,
  ) async {
    if (state.isLoadingOrders ||
        state.isRefreshingOrders ||
        state.isLoadingMoreOrders ||
        !state.hasMorePages) {
      return;
    }

    final nextPage = state.currentPage + 1;
    emit(
      state.copyWith(isLoadingMoreOrders: true, clearLoadMoreOrdersError: true),
    );

    try {
      final result = await getOrdersUseCase(
        page: nextPage,
        perPage: PaginationConstants.ordersPageSize,
      );
      emit(
        state.copyWith(
          orders: mergeWithoutDuplicates(
            state.orders,
            result.items,
            (order) => order.id,
          ),
          isLoadingMoreOrders: false,
          currentPage: result.pagination.currentPage,
          perPage: result.pagination.perPage,
          total: result.pagination.total,
          lastPage: result.pagination.lastPage,
          hasMorePages: result.pagination.hasMorePages,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMoreOrders: false,
          loadMoreOrdersError: _message(e),
        ),
      );
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
        startTime: event.startTime,
        note: event.note,
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
          total: state.total + 1,
          selectedOrder: result.order,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isBookingOrder: false, errorMessage: _message(e)));
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
    emit(
      state.copyWith(
        isLoadingSlots: true,
        clearError: true,
        availableDays: const [],
        clearSelectedDay: true,
        clearSelectedTime: true,
      ),
    );

    try {
      final days = (await getAvailableSlotsUseCase(
        event.packageId,
      )).where((day) => day.hasAvailableSlots).toList();

      final first = days.isEmpty ? null : days.first;

      emit(
        state.copyWith(
          isLoadingSlots: false,
          availableDays: days,
          selectedDay: first,
          selectedTime: first?.slots.first,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingSlots: false, errorMessage: _message(e)));
    }
  }
}
