import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../home/presentation/widgets/app_drawer.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../profile/presentation/bloc/worker_profile_bloc.dart';
import '../bloc/tasks_bloc.dart';
import '../widgets/tasks_body.dart';

/// Screen 1 — the worker's daily tasks.
///
/// Provides the feature-scoped blocs (resolved from `get_it`) that this screen
/// and its top bar / drawer need:
///  - [TasksBloc]          — the daily task list.
///  - [WorkerProfileBloc]  — the account shown in the top bar profile button
///    AND the sidebar header (same account, same source).
///  - [NotificationsBloc]  — the top bar bell's live unread badge.
///
/// The actual UI lives in [TasksBody]; the surrounding [Scaffold] (background +
/// drawer) is here.
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (_) => sl<TasksBloc>()..add(const LoadDailyTasks()),
        ),
        BlocProvider<WorkerProfileBloc>(
          create: (_) => sl<WorkerProfileBloc>()..add(const LoadWorkerProfile()),
        ),
        BlocProvider<NotificationsBloc>(
          create: (_) => sl<NotificationsBloc>()..add(const LoadNotifications()),
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
      // Subtle tinted background so the white task cards stand out (mirrors the
      // design's soft backdrop) — uses the palette, not the mockup's colours.
      backgroundColor: theme.secondaryContainer,
      drawer: const AppDrawer(),
      body: const SafeArea(child: TasksBody()),
    );
  }
}
