import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../profile/presentation/bloc/worker_profile_bloc.dart';
import '../bloc/tasks_bloc.dart';
import '../widgets/tasks_body.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (_) => sl<TasksBloc>()
            ..add(const LoadDailyTasks())
            ..add(const LoadTodayTaskSummary()),
        ),
        BlocProvider<WorkerProfileBloc>(
          create: (_) =>
              sl<WorkerProfileBloc>()..add(const LoadWorkerProfile()),
        ),
        BlocProvider<NotificationsBloc>(
          create: (_) => sl<NotificationsBloc>()
            ..add(const LoadNotifications())
            ..add(const StartNotificationsPolling()),
        ),
      ],
      child: const _TasksView(),
    );
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surfaceContainerLowest,
      body: const SafeArea(child: TasksBody()),
    );
  }
}
