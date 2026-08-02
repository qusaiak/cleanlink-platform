import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });
  final ComplaintEntity complaint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final unread = complaint.hasUnreadResponse;
    final date = complaint.createdAt == null
        ? ''
        : MaterialLocalizations.of(
            context,
          ).formatShortDate(complaint.createdAt!.toLocal());
    final localizedName = complaint.localizedTargetName(
      Localizations.localeOf(context).languageCode,
    );
    final targetName = localizedName.isEmpty
        ? (complaint.type == ComplaintType.company
              ? l.companies_title
              : l.services_title)
        : localizedName;
    final statusLabel = switch (complaint.status) {
      'replied' => l.complaint_replied,
      'reviewed' => l.complaint_reviewed,
      _ => l.complaint_pending,
    };

    return Card(
      key: ValueKey(complaint.id),
      margin: EdgeInsets.zero,
      color: unread
          ? Color.alphaBlend(
              colors.primary.withValues(alpha: 0.07),
              colors.surface,
            )
          : colors.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: complaint.targetImage?.isNotEmpty ?? false
                    ? CustomImageView(
                        imagePath: complaint.targetImage!,
                        width: 76.w,
                        height: 76.w,
                        fit: BoxFit.cover,
                        radius: BorderRadius.circular(12.r),
                      )
                    : Icon(
                        complaint.type == ComplaintType.company
                            ? Icons.business_outlined
                            : Icons.cleaning_services_outlined,
                        size: 32.sp,
                        color: colors.onPrimaryContainer,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            targetName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle14.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (unread) ...[
                          SizedBox(width: 8.w),
                          Container(
                            width: 9.r,
                            height: 9.r,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      complaint.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle12.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      complaint.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle12.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: complaint.hasResponses
                                ? colors.primary.withValues(alpha: 0.12)
                                : colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            statusLabel,
                            style: Styles.textStyle11.copyWith(
                              color: complaint.hasResponses
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (date.isNotEmpty)
                          Text(
                            date,
                            style: Styles.textStyle11.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
