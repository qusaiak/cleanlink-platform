import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/network_avatar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../utils/task_formatting.dart';
import 'task_payment_ui.dart';

class TaskScheduleCard extends StatelessWidget {
  final Task task;
  const TaskScheduleCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    return TaskSectionCard(
      icon: Icons.event_available_outlined,
      title: l.task_schedule_section,
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: [
          _Fact(
            label: l.task_date_label,
            value: formatTaskDate(task.scheduledAt, locale),
          ),
          _Fact(
            label: l.task_time_label,
            value: formatTaskTime(task.scheduledAt),
          ),
          if (task.endAt != null)
            _Fact(
              label: l.task_expected_end,
              value: formatTaskTime(task.endAt!),
            ),
          if (task.durationMinutes != null)
            _Fact(
              label: l.task_duration_label,
              value: l.minutes_value(task.durationMinutes!),
            ),
          if (task.travelBufferMinutes != null && task.travelBufferMinutes! > 0)
            _Fact(
              label: l.task_travel_buffer,
              value: l.minutes_value(task.travelBufferMinutes!),
            ),
        ],
      ),
    );
  }
}

class TaskServicePackageCard extends StatelessWidget {
  final Task task;
  const TaskServicePackageCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return TaskSectionCard(
      icon: Icons.cleaning_services_outlined,
      title: l.task_service_details,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.w700),
          ),
          if (task.serviceDescription.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              task.serviceDescription,
              style: Styles.textStyle12.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
          if (task.packageName.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              task.packageName,
              style: Styles.textStyle14.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (task.packageDetails.isNotEmpty) ...[
            SizedBox(height: 8.h),
            for (final detail in task.packageDetails)
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: colors.primary,
                      size: 17.r,
                    ),
                    SizedBox(width: 7.w),
                    Expanded(
                      child: Text(
                        detail,
                        style: Styles.textStyle12.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (task.minimumWorkers != null) ...[
            SizedBox(height: 7.h),
            Text(
              '${l.task_minimum_workers}: ${task.minimumWorkers}',
              style: Styles.textStyle12.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class TaskClientCard extends StatelessWidget {
  final Task task;
  const TaskClientCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return TaskSectionCard(
      icon: Icons.person_outline_rounded,
      title: l.task_client_section,
      child: Column(
        children: [
          _InfoRow(icon: Icons.badge_outlined, text: task.customerName),
          if (task.customerEmail.isNotEmpty)
            _InfoRow(icon: Icons.email_outlined, text: task.customerEmail),
          if (task.customerPhone.isNotEmpty)
            _InfoRow(icon: Icons.phone_outlined, text: task.customerPhone),
        ],
      ),
    );
  }
}

class TaskTeamCard extends StatelessWidget {
  final Task task;
  const TaskTeamCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final members = task.teamMembers.isNotEmpty
        ? task.teamMembers
        : task.leaderName.isEmpty
        ? const <TaskTeamMember>[]
        : [
            TaskTeamMember(
              id: task.leaderId,
              name: task.leaderName,
              isLeader: true,
              isCurrentWorker: task.isTeamLeader,
            ),
          ];
    if (members.isEmpty && task.leaderName.isEmpty) {
      return const SizedBox.shrink();
    }
    return TaskSectionCard(
      icon: Icons.groups_2_outlined,
      title: l.task_team_section,
      child: Column(
        children: [
          for (int i = 0; i < members.length; i++) ...[
            _TeamMemberTile(member: members[i]),
            if (i != members.length - 1) Divider(height: 18.h),
          ],
        ],
      ),
    );
  }
}

class TaskPaymentCard extends StatelessWidget {
  final Task task;
  const TaskPaymentCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final color = TaskPaymentUi.statusColor(context, task.paymentStatus);
    return TaskSectionCard(
      icon: Icons.payments_outlined,
      title: l.task_payment_section,
      child: Column(
        children: [
          if (task.price > 0)
            _KeyValue(
              label: l.task_price_label,
              value: formatTaskPrice(task.price, task.currency),
            ),
          if (task.paymentMethod.isNotEmpty)
            _KeyValue(
              label: l.task_payment_method,
              value: TaskPaymentUi.methodLabel(context, task.paymentMethod),
            ),
          if (task.paymentStatus.isNotEmpty)
            _KeyValue(
              label: l.task_payment_status,
              value: TaskPaymentUi.statusLabel(context, task.paymentStatus),
              valueColor: color,
            ),
        ],
      ),
    );
  }
}

class TaskNotesCard extends StatelessWidget {
  final Task task;
  const TaskNotesCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) => TaskSectionCard(
    icon: Icons.notes_rounded,
    title: AppLocalizations.of(context)!.task_notes_section,
    child: Text(task.details, style: Styles.textStyle12.copyWith(height: 1.5)),
  );
}

class TaskSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const TaskSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: AppShadow.card(Theme.of(context).brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: colors.primary, size: 20.r),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: Styles.textStyle16.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  final String label;
  final String value;
  const _Fact({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 132.w,
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle11.copyWith(color: colors.onSurfaceVariant),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle12.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      children: [
        Icon(icon, size: 18.r, color: Theme.of(context).colorScheme.primary),
        SizedBox(width: 9.w),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _TeamMemberTile extends StatelessWidget {
  final TaskTeamMember member;
  const _TeamMemberTile({required this.member});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        NetworkAvatar(
          avatarUrl: member.imageUrl,
          radius: 21.r,
          backgroundColor: colors.primaryContainer,
          iconColor: colors.primary,
        ),
        SizedBox(width: 11.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w700),
              ),
              if (member.email.isNotEmpty)
                Text(
                  member.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle11.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 5.w,
          children: [
            if (member.isCurrentWorker)
              _MiniBadge(label: l.task_you_badge, color: colors.primary),
            if (member.isLeader)
              _MiniBadge(
                label: l.task_leader_badge,
                color: const Color(0xFFB7791F),
              ),
          ],
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _MiniBadge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      label,
      style: Styles.textStyle11.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _KeyValue({required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 9.h),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Styles.textStyle12.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          value,
          style: Styles.textStyle12.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
