import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_outlined_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../utils/task_formatting.dart';
import 'task_status_badge.dart';
import 'task_status_ui.dart';

/// A single task in the daily list.
///
/// Shows the service icon, title, request number, customer/location/time and a
/// status badge, plus the actions available for the current [Task.status]:
///  - assigned/paused → Start work (+ navigate)
///  - in progress     → Complete + Pause
/// While [isActing] is true the action area is replaced by a spinner.
///
/// The layout uses logical start/end + EdgeInsetsDirectional so it mirrors
/// automatically between Arabic (RTL) and English (LTR).
class WorkerTaskCard extends StatelessWidget {
  final Task task;
  final bool isActing;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onComplete;
  final VoidCallback onNavigate;

  const WorkerTaskCard({
    super.key,
    required this.task,
    required this.isActing,
    required this.onTap,
    required this.onStart,
    required this.onPause,
    required this.onComplete,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final ui = TaskStatusUi.of(context, task.status);
    final l = AppLocalizations.of(context)!;

    // Time formatting (e.g. "10:00 AM") via the shared dependency-free helper.
    final timeText = formatTaskTime(task.scheduledAt);

    // A start-side accent strip highlights tasks the worker is actively on.
    final showAccent = task.status == TaskStatus.onTheWay ||
        task.status == TaskStatus.inProgress ||
        task.status == TaskStatus.paused;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: theme.onSurface.withValues(alpha: 0.06),
                ),
              ),
              padding: EdgeInsetsDirectional.only(
                start: showAccent ? 20.w : 16.w,
                end: 16.w,
                top: 16.h,
                bottom: 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context, theme, ui, l),
                  SizedBox(height: 12.h),
                  _infoRow(theme, Icons.person_outline_rounded, task.customerName),
                  _infoRow(theme, Icons.location_on_outlined, task.location),
                  _infoRow(theme, Icons.access_time_rounded, timeText),
                  _packageChip(theme),
                  _actions(context, theme, l),
                ],
              ),
            ),
            if (showAccent)
              PositionedDirectional(
                start: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 5.w, color: ui.color),
              ),
          ],
        ),
      ),
    );
  }

  /// Leading 44×44 box: the task's subject photo from the internet when
  /// available, otherwise a coloured service-type icon (also used as the
  /// loading/error placeholder so the layout never jumps).
  Widget _leadingThumb(TaskStatusUi ui) {
    if (task.imageUrl.isEmpty) return _iconBox(ui);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: CachedNetworkImage(
        imageUrl: task.imageUrl,
        width: 44.w,
        height: 44.w,
        fit: BoxFit.cover,
        placeholder: (_, __) => _iconBox(ui),
        errorWidget: (_, __, ___) => _iconBox(ui),
      ),
    );
  }

  Widget _iconBox(TaskStatusUi ui) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: ui.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(serviceTypeIcon(task.serviceType), color: ui.color, size: 22.r),
    );
  }

  Widget _header(
    BuildContext context,
    ColorScheme theme,
    TaskStatusUi ui,
    AppLocalizations l,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _leadingThumb(ui),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              if (task.companyName.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  task.companyName,
                  style: Styles.textStyle12.copyWith(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              SizedBox(height: 4.h),
              Text(
                l.task_request_number(task.requestNumber),
                style: Styles.textStyle12.copyWith(
                  color: theme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        TaskStatusBadge(status: task.status),
      ],
    );
  }

  /// A pill showing the selected package and its price, e.g. "Studio · $75".
  /// Only shown when the booking carries package/price info.
  Widget _packageChip(ColorScheme theme) {
    final hasPackage = task.packageName.isNotEmpty;
    final hasPrice = task.price > 0;
    if (!hasPackage && !hasPrice) return const SizedBox.shrink();

    final priceText = formatTaskPrice(task.price, task.currency);
    final label = hasPackage && hasPrice
        ? '${task.packageName} · $priceText'
        : hasPackage
            ? task.packageName
            : priceText;

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer_outlined, size: 14.r, color: theme.primary),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                label,
                style: Styles.textStyle12.copyWith(
                  color: theme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(ColorScheme theme, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: theme.onSurfaceVariant),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the status-appropriate action area, or a spinner while acting.
  Widget _actions(BuildContext context, ColorScheme theme, AppLocalizations l) {
    // Completed/cancelled tasks have no further actions.
    if (task.status == TaskStatus.completed ||
        task.status == TaskStatus.cancelled) {
      return const SizedBox.shrink();
    }

    if (isActing) {
      return Padding(
        padding: EdgeInsets.only(top: 14.h),
        child: SizedBox(
          height: 48.h,
          child: Center(child: spinKitApp(theme.primary)),
        ),
      );
    }

    final children = <Widget>[];
    switch (task.status) {
      case TaskStatus.assigned:
      case TaskStatus.onTheWay:
        children.addAll([
          Expanded(
            child: _filledButton(
              theme.primary,
              l.task_action_start,
              Icons.play_arrow_rounded,
              onStart,
            ),
          ),
          SizedBox(width: 12.w),
          _navigateButton(theme),
        ]);
        break;
      case TaskStatus.inProgress:
        children.addAll([
          Expanded(
            child: _filledButton(
              AppColor.successColor,
              l.task_action_complete,
              Icons.check_circle_outline_rounded,
              onComplete,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(child: _pauseButton(theme, l)),
        ]);
        break;
      case TaskStatus.paused:
        children.addAll([
          Expanded(
            child: _filledButton(
              theme.primary,
              l.task_action_start,
              Icons.play_arrow_rounded,
              onStart,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _filledButton(
              AppColor.successColor,
              l.task_action_complete,
              Icons.check_circle_outline_rounded,
              onComplete,
            ),
          ),
        ]);
        break;
      case TaskStatus.completed:
      case TaskStatus.cancelled:
        break;
    }

    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(children: children),
    );
  }

  Widget _filledButton(
    Color color,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return CustomElevatedButton(
      text: text,
      height: 48.h,
      onPressed: onPressed,
      leftIcon: Icon(icon, color: Colors.white, size: 18.r),
      buttonTextStyle: Styles.textStyle14.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _pauseButton(ColorScheme theme, AppLocalizations l) {
    return CustomOutlinedButton(
      text: l.task_action_pause,
      height: 48.h,
      onPressed: onPause,
      leftIcon: Icon(Icons.pause_rounded, color: theme.primary, size: 18.r),
      buttonTextStyle: Styles.textStyle14.copyWith(
        color: theme.primary,
        fontWeight: FontWeight.w600,
      ),
      buttonStyle: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  /// Square "open maps / directions" button shown beside Start.
  Widget _navigateButton(ColorScheme theme) {
    return InkWell(
      onTap: onNavigate,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 48.h,
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.primary),
        ),
        child: Icon(Icons.directions_rounded, color: theme.primary, size: 20.r),
      ),
    );
  }
}
