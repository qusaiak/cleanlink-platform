part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();
  @override
  List<Object?> get props => [];
}

class GetOrdersEvent extends BookingsEvent {
  final bool isRefresh;
  final Completer<void>? completer;

  const GetOrdersEvent({this.isRefresh = false, this.completer});

  @override
  List<Object?> get props => [isRefresh, completer];
}

class GetBookings extends GetOrdersEvent {
  const GetBookings();
}

class RefreshBookings extends GetOrdersEvent {
  const RefreshBookings({super.completer}) : super(isRefresh: true);
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
  final double latitude;
  final double longitude;
  final DateTime startTime;
  final String? note;
  final PaymentMethodType paymentMethod;
  const BookOrderEvent({
    required this.packageId,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.startTime,
    this.note,
    this.paymentMethod = PaymentMethodType.cash,
  });
  @override
  List<Object?> get props => [
    packageId,
    location,
    latitude,
    longitude,
    startTime,
    note,
    paymentMethod,
  ];
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
  final double latitude;
  final double longitude;
  const LoadAvailableSlots({
    required this.packageId,
    required this.latitude,
    required this.longitude,
  });
  @override
  List<Object?> get props => [packageId, latitude, longitude];
}

class SelectBookingLocation extends BookingsEvent {
  const SelectBookingLocation({
    required this.packageId,
    required this.location,
  });

  final int packageId;
  final SelectedMapLocation location;

  @override
  List<Object?> get props => [packageId, location];
}

class ClearBookingLocation extends BookingsEvent {
  const ClearBookingLocation();
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

class ConfigureBookingPackage extends BookingsEvent {
  const ConfigureBookingPackage({
    required this.package,
    required this.attributes,
  });
  final PackageEntity package;
  final List<AttributeEntity> attributes;
  @override
  List<Object?> get props => [package, attributes];
}

class UpdateOpenPackageAttributeQty extends BookingsEvent {
  const UpdateOpenPackageAttributeQty({
    required this.attributeId,
    required this.qty,
  });
  final int attributeId;
  final int qty;
  @override
  List<Object?> get props => [attributeId, qty];
}

class CheckOpenPackagePrice extends BookingsEvent {
  const CheckOpenPackagePrice(this.packageId);
  final int packageId;
  @override
  List<Object?> get props => [packageId];
}
