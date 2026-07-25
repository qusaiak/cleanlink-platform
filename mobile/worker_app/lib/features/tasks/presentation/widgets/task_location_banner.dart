import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/styles.dart';
import '../../domain/entities/task.dart';

/// Decorative location header for the task-detail screen.
///
/// The design shows a stylised map graphic; since the app has no maps package,
/// this renders an on-palette gradient banner with a location icon and a chip
/// showing the address. Tapping opens the device maps app at the location.
class TaskLocationBanner extends StatelessWidget {
  final Task task;

  const TaskLocationBanner({super.key, required this.task});

  Future<void> _openMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query='
      '${Uri.encodeComponent(task.location)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final hasImage = task.imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: _openMaps,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          height: 150.h,
          // Gradient base: acts as the fallback if there is no subject image
          // or it fails to load.
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.primary, theme.primary.withValues(alpha: 0.7)],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              // Subject photo from the internet (e.g. the AC unit).
              if (hasImage)
                CachedNetworkImage(
                  imageUrl: task.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const SizedBox.shrink(),
                  // On failure, fall back to the gradient base.
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              // Dark overlay so the address chip stays legible over any image.
              if (hasImage)
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.45),
                      ],
                    ),
                  ),
                ),
              // When there's no image, keep the decorative map/location icons.
              if (!hasImage) ...[
                Icon(
                  Icons.map_rounded,
                  size: 64.r,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                Icon(Icons.location_on, size: 34.r, color: Colors.white),
              ],
              // Address chip pinned to the bottom.
              PositionedDirectional(
              start: 12.w,
              end: 12.w,
              bottom: 12.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16.r, color: theme.primary),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        task.location,
                        style: Styles.textStyle12.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.directions_rounded,
                        size: 18.r, color: theme.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
