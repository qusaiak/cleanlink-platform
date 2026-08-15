import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../widgets/custom_tile.dart';

/// Grouped card with the worker's job id, email, phone, address and
/// leader-status rows.
/// Reuses the existing [CustomTile] (icon + title + subtitle). The email,
/// phone and address rows show an edit button so the worker can update the
/// value — [onEditEmail] / [onEditPhone] / [onEditAddress] are invoked when
/// the matching edit button is tapped. The job id and leader rows are
/// read-only; the leader row ([leaderLabel] + [leaderValue]) states plainly
/// whether this worker leads a team, e.g. "Leader" / "Not a Leader".
class CustomInfoTileCard extends StatelessWidget {
  final String jobIdLabel;
  final String jobId;
  final String emailLabel;
  final String email;
  final String phoneLabel;
  final String phone;
  final String addressLabel;
  final String address;
  final String leaderLabel;
  final String leaderValue;
  final bool isLeader;
  final VoidCallback? onEditEmail;
  final VoidCallback? onEditPhone;
  final VoidCallback? onEditAddress;

  const CustomInfoTileCard({
    super.key,
    required this.jobIdLabel,
    required this.jobId,
    required this.emailLabel,
    required this.email,
    required this.phoneLabel,
    required this.phone,
    required this.addressLabel,
    required this.address,
    required this.leaderLabel,
    required this.leaderValue,
    required this.isLeader,
    this.onEditEmail,
    this.onEditPhone,
    this.onEditAddress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final dividerColor = theme.onSurface.withValues(alpha: 0.06);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        children: [
          // Job id is the account id — read-only.
          CustomTile(
            icon: Icons.badge_outlined,
            title: jobIdLabel,
            subtitle: jobId,
            trailing: const SizedBox.shrink(),
          ),
          Divider(height: 8.h, color: dividerColor),
          CustomTile(
            icon: Icons.email_outlined,
            title: emailLabel,
            subtitle: email,
            onTap: onEditEmail,
            trailing: _editButton(onEditEmail),
          ),
          Divider(height: 8.h, color: dividerColor),
          CustomTile(
            icon: Icons.phone_outlined,
            title: phoneLabel,
            subtitle: phone,
            onTap: onEditPhone,
            trailing: _editButton(onEditPhone),
          ),
          Divider(height: 8.h, color: dividerColor),
          CustomTile(
            icon: Icons.location_on_outlined,
            title: addressLabel,
            subtitle: address,
            onTap: onEditAddress,
            trailing: _editButton(onEditAddress),
          ),
          Divider(height: 8.h, color: dividerColor),
          // Leader status — "Leader" for workgroup leaders, "Not a Leader"
          // for everyone else.
          CustomTile(
            icon: isLeader
                ? Icons.workspace_premium_outlined
                : Icons.shield_outlined,
            title: leaderLabel,
            subtitle: leaderValue,
            trailing: const SizedBox.shrink(),
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
