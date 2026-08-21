import 'package:equatable/equatable.dart';

class TodayTaskSummary extends Equatable {
  final int pending;
  final int done;

  const TodayTaskSummary({required this.pending, required this.done});

  @override
  List<Object> get props => [pending, done];
}
