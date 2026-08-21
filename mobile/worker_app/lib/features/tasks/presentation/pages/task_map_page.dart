import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';

class TaskMapPage extends StatelessWidget {
  final Task task;

  const TaskMapPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final lat = task.latitude;
    final lng = task.longitude;
    final hasCoordinates = lat != null && lng != null;
    final position = hasCoordinates ? LatLng(lat, lng) : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(l.task_location_section),
      ),
      body: Stack(
        children: [
          if (position != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 15.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('task'),
                  position: position,
                  infoWindow: InfoWindow(
                    title: task.title,
                    snippet: task.location,
                  ),
                ),
              },
              myLocationButtonEnabled: false,
              compassEnabled: true,
              zoomControlsEnabled: false,
            )
          else
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  l.task_map_unavailable,
                  textAlign: TextAlign.center,
                  style: Styles.textStyle14.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          PositionedDirectional(
            start: 16.w,
            end: 16.w,
            bottom: 16.h,
            child: SafeArea(
              top: false,
              child: Material(
                color: colors.surface,
                elevation: 4,
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: colors.primary),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          task.location,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle14.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
