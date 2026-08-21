import 'package:equatable/equatable.dart';

import 'task.dart';

class DailyTasks extends Equatable {
  final List<Task> tasks;

  const DailyTasks({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}
