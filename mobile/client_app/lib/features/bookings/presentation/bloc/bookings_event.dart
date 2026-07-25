part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();
  @override
  List<Object?> get props => [];
}

class GetOrdersEvent extends BookingsEvent {
  const GetOrdersEvent();
}

class GetBookings extends GetOrdersEvent {
  const GetBookings();
}

class RefreshBookings extends GetOrdersEvent {
  const RefreshBookings();
}

class ShowOrderEvent extends BookingsEvent {
  final int orderId;
  const ShowOrderEvent(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

class CancelOrderEvent extends BookingsEvent {
  final int orderId;
  const CancelOrderEvent(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

class BookOrderEvent extends BookingsEvent {
  final int packageId;
  final String location;
  final DateTime startTime;
  final String? note;
  const BookOrderEvent({
    required this.packageId,
    required this.location,
    required this.startTime,
    this.note,
  });
  @override
  List<Object?> get props => [packageId, location, startTime, note];
}

class ResetBookingStateEvent extends BookingsEvent {
  const ResetBookingStateEvent();
}

class ChangeTab extends BookingsEvent {
  final BookingTab tab;
  const ChangeTab(this.tab);
  @override
  List<Object?> get props => [tab];
}

class LoadAvailableSlots extends BookingsEvent {
  final int packageId;
  const LoadAvailableSlots(this.packageId);
  @override
  List<Object?> get props => [packageId];
}

class SelectDate extends BookingsEvent {
  final AvailableDayEntity day;
  const SelectDate(this.day);
  @override
  List<Object?> get props => [day];
}

class SelectTime extends BookingsEvent {
  final String time;
  const SelectTime(this.time);
  @override
  List<Object?> get props => [time];
}
