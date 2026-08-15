import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/task.dart';

/// Header banner for the task-detail screen: the service provider's company
/// photo (`service.company.image`). Falls back to a decorative gradient with
/// map/location icons when the company has no photo. Tapping it still opens
/// the device maps app at the task's location.
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
    final hasImage = task.companyImageUrl.isNotEmpty;

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
              // The company's photo.
              if (hasImage)
                CachedNetworkImage(
                  imageUrl: task.companyImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const SizedBox.shrink(),
                  // On failure, fall back to the gradient base.
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
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
            ],
          ),
        ),
      ),
    );
  }
}
