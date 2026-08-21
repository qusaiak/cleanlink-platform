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

Future<Task?> openTaskById(
  BuildContext context,
  String idOrRequest, {
  bool refreshTasksOnReturn = true,
}) async {
  if (refreshTasksOnReturn) TasksRefreshSignal.instance.requestRefresh();
  final l = AppLocalizations.of(context)!;
  final theme = Theme.of(context).colorScheme;
  final navigator = Navigator.of(context, rootNavigator: true);

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    builder: (_) => Center(child: spinKitApp(theme.primary)),
  );

  final result = await sl<GetTaskByIdUseCase>()(params: idOrRequest);

  if (navigator.canPop()) navigator.pop();
  if (!context.mounted) return null;

  return result.fold<Future<Task?>>((failure) async {
    showAppSnackBar(
      context,
      message: failure.message.isNotEmpty
          ? failure.message
          : l.task_open_failed,
      type: SnackBarType.error,
    );
    return null;
  }, (task) => context.push<Task>(AppRouter.kTaskDetails, extra: task));
}
