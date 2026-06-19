import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/get_task_by_id_usecase.dart';

/// Opens the task-detail screen for the task identified by [idOrRequest].
///
/// Search results and notifications only carry an identifier (a task id or a
/// request number), not the full [Task]. This helper fetches the task through
/// [GetTaskByIdUseCase] (live backend when available, in-memory data otherwise),
/// showing a brief blocking loader, then pushes [AppRouter.kTaskDetails] with
/// the resolved task. On failure it surfaces an error snackbar.
///
/// Centralised so both the search and notifications features open tasks the
/// same way the daily-tasks list does.
Future<void> openTaskById(BuildContext context, String idOrRequest) async {
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
  if (!context.mounted) return;

  result.fold(
    (failure) => showAppSnackBar(
      context,
      message: failure.message.isNotEmpty ? failure.message : l.task_open_failed,
      type: SnackBarType.error,
    ),
    (task) => context.push(AppRouter.kTaskDetails, extra: task),
  );
}
