import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../widgets/custom_tile.dart';

/// Grouped card with the worker's job id and email rows. Reuses the existing
/// [CustomTile] (icon + title + subtitle) and shows an edit button on each row
/// so the worker can update the value. [onEditJobId] / [onEditEmail] are
/// invoked when the matching edit button is tapped.
class CustomInfoTileCard extends StatelessWidget {
  final String jobIdLabel;
  final String jobId;
  final String emailLabel;
  final String email;
  final VoidCallback? onEditJobId;
  final VoidCallback? onEditEmail;

  const CustomInfoTileCard({
    super.key,
    required this.jobIdLabel,
    required this.jobId,
    required this.emailLabel,
    required this.email,
    this.onEditJobId,
    this.onEditEmail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          CustomTile(
            icon: Icons.badge_outlined,
            title: jobIdLabel,
            subtitle: jobId,
            onTap: onEditJobId,
            trailing: _editButton(onEditJobId),
          ),
          Divider(height: 8.h, color: theme.onSurface.withValues(alpha: 0.06)),
          CustomTile(
            icon: Icons.email_outlined,
            title: emailLabel,
            subtitle: email,
            onTap: onEditEmail,
            trailing: _editButton(onEditEmail),
          ),
        ],
      ),
    );
  }

  /// Pencil button shown on the trailing edge of each editable row.
  Widget _editButton(VoidCallback? onPressed) {
    return IconButton(
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      icon: const Icon(
        Icons.edit_outlined,
        size: 18,
        color: AppColor.primaryColor,
      ),
    );
  }
}
