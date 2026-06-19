import 'package:equatable/equatable.dart';

import 'task.dart';
import 'task_stats.dart';

/// Aggregate returned by a single "load the worker's day" call: the summary
/// [stats] for the header cards plus the [tasks] list. Bundling them lets the
/// UI hydrate the whole screen from one request (one API endpoint).
class DailyTasks extends Equatable {
  final TaskStats stats;
  final List<Task> tasks;

  const DailyTasks({required this.stats, required this.tasks});

  @override
  List<Object?> get props => [stats, tasks];
}
