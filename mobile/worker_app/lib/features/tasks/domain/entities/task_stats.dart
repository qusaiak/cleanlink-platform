import 'package:equatable/equatable.dart';

/// Aggregated counters shown in the two summary cards at the top of the daily
/// tasks screen: "المتبقي اليوم" (remaining) and "المهام المنجزة" (completed/total).
class TaskStats extends Equatable {
  /// Tasks still to be done today (the "•3" card).
  final int remainingToday;

  /// Tasks finished today (the numerator of "12 / 15").
  final int completed;

  /// Total tasks scheduled today (the denominator of "12 / 15").
  final int total;

  const TaskStats({
    required this.remainingToday,
    required this.completed,
    required this.total,
  });

  @override
  List<Object?> get props => [remainingToday, completed, total];
}
