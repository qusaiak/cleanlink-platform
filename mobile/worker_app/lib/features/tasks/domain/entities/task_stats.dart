import 'package:equatable/equatable.dart';

class TaskStats extends Equatable {
  final int remainingToday;

  final int completed;

  final int total;

  const TaskStats({
    required this.remainingToday,
    required this.completed,
    required this.total,
  });

  @override
  List<Object?> get props => [remainingToday, completed, total];
}
