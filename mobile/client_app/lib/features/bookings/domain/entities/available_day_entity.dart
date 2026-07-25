import 'package:equatable/equatable.dart';

class AvailableDayEntity extends Equatable {
  final DateTime date;
  final List<String> slots;

  const AvailableDayEntity({required this.date, required this.slots});

  bool get hasAvailableSlots => slots.isNotEmpty;

  @override
  List<Object?> get props => [date, slots];
}
