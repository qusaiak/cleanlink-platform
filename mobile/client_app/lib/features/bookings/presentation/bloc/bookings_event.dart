part of 'bookings_bloc.dart';

abstract class BookingsEvent
    extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

class GetBookings
    extends BookingsEvent {
  const GetBookings();
}

class RefreshBookings
    extends BookingsEvent {
  const RefreshBookings();
}

class LoadMoreBookings
    extends BookingsEvent {
  const LoadMoreBookings();
}

class ChangeTab
    extends BookingsEvent {
  final BookingTab tab;

  const ChangeTab(
      this.tab,
      );

  @override
  List<Object?> get props => [
    tab,
  ];
}
