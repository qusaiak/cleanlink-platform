import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../widgets/custom_tile.dart';

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
        ],
      ),
    );
  }

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
