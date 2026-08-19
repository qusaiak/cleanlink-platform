import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../utils/task_formatting.dart';
import 'task_status_badge.dart';
import 'task_status_ui.dart';

/// A single task in the daily list.
///
/// Shows exactly the public attributes of a worker-tasks-log entry: image,
/// the workgroup leader's full name + id (the public payload carries no
/// client name), location, status, order duration, total price and date —
/// plus one action: advancing the task to the single next status of the
/// strict `pending → on_way → handling → done` sequence (via [onAdvance],
/// leader only). Going backward or skipping a step is never offered.
/// Tapping the location row (rather than a separate button) opens it in the
/// device's maps app via [onNavigate].
///
/// The layout uses logical start/end + EdgeInsetsDirectional so it mirrors
/// automatically between Arabic (RTL) and English (LTR).
class WorkerTaskCard extends StatelessWidget {
  final Task task;
  final bool isActing;
  final VoidCallback onTap;
  final VoidCallback onAdvance;
  final VoidCallback onNavigate;

  const WorkerTaskCard({
    super.key,
    required this.task,
    required this.isActing,
    required this.onTap,
    required this.onAdvance,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final ui = TaskStatusUi.of(context, task.status);
    final l = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    // Date formatting (e.g. "24 May 2024") via the shared dependency-free helper.
    final dateText = formatTaskDate(task.scheduledAt, localeCode);

    // A start-side accent strip highlights tasks the worker is actively on.
    final showAccent =
        task.status == TaskStatus.onTheWay ||
        task.status == TaskStatus.inProgress ||
        task.status == TaskStatus.paused;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
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
                  _header(theme, ui),
                  SizedBox(height: 12.h),
                  _locationRow(theme),
                  if (task.durationLabel.isNotEmpty)
                    _infoRow(
                      theme,
                      Icons.timelapse_rounded,
                      task.durationLabel,
                    ),
                  _infoRow(theme, Icons.calendar_today_rounded, dateText),
                  _priceChip(theme, l),
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
      borderRadius: BorderRadius.circular(AppRadius.sm),
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
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(
        serviceTypeIcon(task.serviceType),
        color: ui.color,
        size: 22.r,
      ),
    );
  }

  /// Header: image, the workgroup leader's full name (+ id) and the status
  /// badge — the leader's name/id stand in for the (unavailable) client name.
  Widget _header(ColorScheme theme, TaskStatusUi ui) {
    // Show the CLIENT's name (`order.client.fullname`, parsed into
    // `customerName`), not the worker/leader. `customerName` is null-safe: the
    // model falls back to `Client #<id>` when the client name is absent, so
    // this never renders an empty string.
    final name = task.customerName;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _leadingThumb(ui),
        SizedBox(width: 12.w),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (task.leaderId.isNotEmpty) ...[
                SizedBox(width: 6.w),
                Text(
                  '#${task.leaderId}',
                  style: Styles.textStyle12.copyWith(
                    color: theme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: 8.w),
        TaskStatusBadge(status: task.status),
      ],
    );
  }

  /// A pill showing the order's total price, e.g. "$75".
  /// Only shown when the booking carries a price.
  Widget _priceChip(ColorScheme theme, AppLocalizations l) {
    if (task.price <= 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.xxl),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.payments_outlined, size: 14.r, color: theme.primary),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                '${l.task_price_label}: ${formatTaskPrice(task.price, task.currency)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  /// Same layout as [_infoRow], but tappable: opens the task's location in
  /// the device's maps app (reusing [onNavigate], previously wired to a
  /// separate "go to location" button). The primary-coloured, underlined
  /// text is the visual cue that this row — not just the text glyphs — is
  /// interactive.
  Widget _locationRow(ColorScheme theme) {
    return InkWell(
      onTap: onNavigate,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16.r, color: theme.primary),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                task.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.textStyle12.copyWith(
                  color: theme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: theme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the single sequential action for the current [Task.status] —
  /// advance to the next step (leader only) — or a spinner while [isActing].
  /// The strict sequence means there is never more than one legal action.
  Widget _actions(BuildContext context, ColorScheme theme, AppLocalizations l) {
    // End of the sequence (or a legacy paused/cancelled task), or a
    // non-leader crew member → nothing to act on.
    final next = task.status.next;
    if (next == null || !task.isTeamLeader) return const SizedBox.shrink();

    if (isActing) {
      return Padding(
        padding: EdgeInsets.only(top: 14.h),
        child: SizedBox(
          height: 48.h,
          child: Center(child: spinKitApp(theme.primary)),
        ),
      );
    }

    final isDoneStep = next == TaskStatus.completed;
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        children: [
          Expanded(
            child: _filledButton(
              isDoneStep ? AppColor.successColor : theme.primary,
              l.task_advance_to(TaskStatusUi.of(context, next).label),
              isDoneStep
                  ? Icons.check_circle_outline_rounded
                  : Icons.arrow_forward_rounded,
              onAdvance,
            ),
          ),
        ],
      ),
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
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}
