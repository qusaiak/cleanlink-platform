import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/network_avatar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/worker_profile.dart';
import 'worker_availability_ui.dart';

class WorkerProfileHeader extends StatelessWidget {
  final WorkerProfile profile;

  final WorkerAvailability? effectiveAvailability;
  final VoidCallback? onEditPhoto;
  final VoidCallback? onEditName;

  final XFile? previewImage;

  final bool uploadingPhoto;

  const WorkerProfileHeader({
    super.key,
    required this.profile,
    this.effectiveAvailability,
    this.onEditPhoto,
    this.onEditName,
    this.previewImage,
    this.uploadingPhoto = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    final ringColor = WorkerAvailabilityUi.of(
      context,
      effectiveAvailability ?? profile.availability,
    ).color;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 3),
              ),
              child: _avatar(theme),
            ),
            if (profile.isVerified)
              PositionedDirectional(
                end: 4.w,
                top: 2.h,
                child: Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    color: AppColor.successColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 14.r,
                    color: Colors.white,
                  ),
                ),
              ),

            if (onEditPhoto != null)
              PositionedDirectional(
                end: 0,
                bottom: 0,
                child: Material(
                  color: theme.primary,
                  shape: CircleBorder(
                    side: BorderSide(color: theme.surface, width: 2),
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onEditPhoto,
                    child: Padding(
                      padding: EdgeInsets.all(6.r),
                      child: Icon(
                        Icons.photo_camera_rounded,
                        size: 15.r,
                        color: theme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                profile.name,
                textAlign: TextAlign.center,
                style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8.w),

            if (onEditName != null)
              IconButton(
                onPressed: onEditName,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.edit_outlined,
                  size: 18.r,
                  color: theme.primary,
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        _roleBadge(theme, l),
      ],
    );
  }

  Widget _avatar(ColorScheme theme) {
    if (previewImage == null) {
      return NetworkAvatar(
        avatarUrl: profile.avatarUrl,
        radius: 48.r,
        backgroundColor: theme.primary.withValues(alpha: 0.1),
        iconColor: theme.primary,
      );
    }
    final double diameter = 96.r;
    return ClipOval(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<Uint8List>(
              future: previewImage!.readAsBytes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ColoredBox(
                    color: theme.primary.withValues(alpha: 0.1),
                  );
                }
                return Image.memory(snapshot.data!, fit: BoxFit.cover);
              },
            ),
            if (uploadingPhoto)
              ColoredBox(
                color: Colors.black.withValues(alpha: 0.35),
                child: Center(child: spinKitApp(Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _roleBadge(ColorScheme theme, AppLocalizations l) {
    final color = theme.primary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.engineering_outlined, size: 15.r, color: color),
          SizedBox(width: 5.w),
          Text(
            l.profile_worker_badge,
            style: Styles.textStyle12.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
