import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_task_by_id_usecase.dart';
import 'tasks_refresh_signal.dart';

/// Opens the task-detail screen for the task identified by [idOrRequest].
///
/// Search results and notifications only carry an identifier (a task id or a
/// request number), not the full [Task]. This helper fetches the task through
/// [GetTaskByIdUseCase] (live backend when available, in-memory data otherwise),
/// showing a brief blocking loader, then pushes [AppRouter.kTaskDetails] with
/// the resolved task. On failure it surfaces an error snackbar.
///
/// Returns the task as it stood when the detail screen closed **if** its status
/// was advanced there (the detail pops with the updated [Task]); returns `null`
/// when the fetch failed or the worker left without changing anything. Callers
/// that own a list (the daily-tasks screen) apply this back into their state so
/// the change shows immediately, with no reload.
///
/// Centralised so both the search and notifications features open tasks the
/// same way the daily-tasks list does.
///
/// When [refreshTasksOnReturn] is true (the default) opening a task also asks
/// the daily-tasks list to reload via [TasksRefreshSignal]. This is what makes
/// a task opened from a notification tap — in-app, background, or a terminated
/// cold start, all of which route here through `NotificationService` — appear
/// in the list without a manual pull-to-refresh. Callers that already own a
/// live list (the daily-tasks cards) pass `false`, since the repository stream
/// keeps them current on its own.
Future<Task?> openTaskById(
  BuildContext context,
  String idOrRequest, {
  bool refreshTasksOnReturn = true,
}) async {
  if (refreshTasksOnReturn) TasksRefreshSignal.instance.requestRefresh();
  final l = AppLocalizations.of(context)!;
  final theme = Theme.of(context).colorScheme;
  final navigator = Navigator.of(context, rootNavigator: true);

  // Brief blocking loader while the task is fetched.
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    builder: (_) => Center(child: spinKitApp(theme.primary)),
  );

  final result = await sl<GetTaskByIdUseCase>()(params: idOrRequest);

  // Dismiss the loader. Guard against a disposed context (user navigated away).
  if (navigator.canPop()) navigator.pop();
  if (!context.mounted) return null;

  return result.fold<Future<Task?>>(
    (failure) async {
      showAppSnackBar(
        context,
        message: failure.message.isNotEmpty
            ? failure.message
            : l.task_open_failed,
        type: SnackBarType.error,
      );
      return null;
    },
    // Await the pushed route: `context.push` completes only when the detail
    // screen is popped, carrying the updated task the detail returns on a
    // successful status change (or null on a plain back-navigation).
    (task) => context.push<Task>(AppRouter.kTaskDetails, extra: task),
  );
}
