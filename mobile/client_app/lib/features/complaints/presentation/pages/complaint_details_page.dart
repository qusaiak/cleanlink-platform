import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/complaint_entity.dart';
import '../bloc/complaints_bloc.dart';

class ComplaintDetailsPage extends StatefulWidget {
  const ComplaintDetailsPage({super.key, required this.complaintId});

  final int complaintId;

  @override
  State<ComplaintDetailsPage> createState() => _ComplaintDetailsPageState();
}

class _ComplaintDetailsPageState extends State<ComplaintDetailsPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<ComplaintsBloc>().add(
      LoadComplaintDetailsEvent(widget.complaintId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l.complaint_details)),
      body: BlocBuilder<ComplaintsBloc, ComplaintsState>(
        builder: (context, state) {
          if (state.isLoadingDetails) {
            return Center(child: spinKitApp(colors.primary));
          }
          if (state.detailsError != null) {
            return Center(
              child: AppEmptyState(
                icon: Icons.error_outline,
                title: l.could_not_load_complaints,
                body: state.detailsError,
                action: FilledButton(onPressed: _load, child: Text(l.retry)),
              ),
            );
          }

          final complaint = state.selectedComplaint;
          if (complaint == null) return const SizedBox.shrink();

          return RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<ComplaintsBloc>()
                ..add(LoadComplaintDetailsEvent(widget.complaintId));
              await bloc.stream.firstWhere((state) => !state.isLoadingDetails);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
              children: [
                _TargetCard(complaint: complaint),
                SizedBox(height: 14.h),
                _ComplaintContentCard(complaint: complaint),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.complaint_replies,
                        style: Styles.textStyle16.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${complaint.responses.length}',
                        style: Styles.textStyle12.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (complaint.responses.isEmpty)
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: AppEmptyState(
                        icon: Icons.forum_outlined,
                        title: l.no_complaint_replies,
                      ),
                    ),
                  )
                else
                  ...complaint.responses.map(
                    (reply) => _ReplyCard(reply: reply),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({required this.complaint});

  final ComplaintEntity complaint;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final name = complaint.localizedTargetName(
      Localizations.localeOf(context).languageCode,
    );
    final status = switch (complaint.status) {
      'replied' => l.complaint_replied,
      'reviewed' => l.complaint_reviewed,
      _ => l.complaint_pending,
    };

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: complaint.targetImage?.isNotEmpty ?? false
                  ? CustomImageView(
                      imagePath: complaint.targetImage!,
                      width: 72.w,
                      height: 72.w,
                      fit: BoxFit.cover,
                      radius: BorderRadius.circular(14.r),
                    )
                  : Icon(
                      complaint.type == ComplaintType.company
                          ? Icons.business_outlined
                          : Icons.cleaning_services_outlined,
                      color: colors.onPrimaryContainer,
                      size: 32.sp,
                    ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Styles.textStyle16.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: [
                      _Pill(
                        label: complaint.type == ComplaintType.company
                            ? l.companies_title
                            : l.services_title,
                        foreground: colors.primary,
                        background: colors.primary.withValues(alpha: 0.1),
                      ),
                      _Pill(
                        label: status,
                        foreground: complaint.hasResponses
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        background: complaint.hasResponses
                            ? colors.primary.withValues(alpha: 0.1)
                            : colors.surfaceContainerHighest,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplaintContentCard extends StatelessWidget {
  const _ComplaintContentCard({
    required this.complaint,
  });

  final ComplaintEntity complaint;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.7),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              20.w,
              18.h,
              18.w,
              18.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ComplaintFieldHeader(
                  icon: Icons.notes_rounded,
                  label: l.complaint_subject,
                ),
                SizedBox(height: 10.h),
                SelectableText(
                  complaint.title,
                  style: Styles.textStyle16.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 14.h),
                _ComplaintFieldHeader(
                  icon: Icons.subject_rounded,
                  label: l.complaint_message,
                ),
                SizedBox(height: 10.h),
                SelectableText(
                  complaint.body,
                  style: Styles.textStyle14.copyWith(
                    color: colors.onSurface,
                    height: 1.6,
                  ),
                ),
                if (complaint.createdAt != null) ...[
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16.sp,
                        color: colors.onSurfaceVariant,
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Text(
                          _formatDate(
                            context,
                            complaint.createdAt!,
                          ),
                          style: Styles.textStyle11.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplaintFieldHeader extends StatelessWidget {
  const _ComplaintFieldHeader({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: colors.primary,
        ),
        SizedBox(width: 7.w),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.textStyle12.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
class _ReplyCard extends StatelessWidget {
  const _ReplyCard({required this.reply});

  final ComplaintReplyEntity reply;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final role = switch (reply.replierRole) {
      'company_manager' => l.company_manager_label,
      'admin' => l.support_team_label,
      _ => null,
    };
    final author = reply.replierName?.trim();

    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      color: colors.primary.withValues(alpha: 0.045),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21.r,
              backgroundColor: colors.primaryContainer,
              child: Icon(
                Icons.support_agent_rounded,
                color: colors.onPrimaryContainer,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (author?.isNotEmpty ?? false)
                    Text(
                      author!,
                      style: Styles.textStyle14.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (role != null) ...[
                    if (author?.isNotEmpty ?? false) SizedBox(height: 2.h),
                    Text(
                      role,
                      style: Styles.textStyle11.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if ((author?.isNotEmpty ?? false) || role != null)
                    SizedBox(height: 10.h),
                  SelectableText(
                    reply.message,
                    style: Styles.textStyle14.copyWith(
                      color: colors.onSurface,
                      height: 1.45,
                    ),
                  ),
                  if (reply.createdAt != null) ...[
                    SizedBox(height: 10.h),
                    Text(
                      _formatDate(context, reply.createdAt!),
                      style: Styles.textStyle11.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      label,
      style: Styles.textStyle11.copyWith(
        color: foreground,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

String _formatDate(BuildContext context, DateTime date) => DateFormat.yMMMd(
  Localizations.localeOf(context).languageCode,
).add_jm().format(date.toLocal());
