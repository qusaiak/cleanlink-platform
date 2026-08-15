import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../locations/domain/entities/selected_map_location.dart';

class BookingLocationSelector extends StatelessWidget {
  const BookingLocationSelector({
    super.key,
    required this.location,
    required this.onTap,
  });

  final SelectedMapLocation? location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.service_location,
          style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Ink(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: location == null
                    ? colors.outline.withValues(alpha: 0.35)
                    : colors.primary.withValues(alpha: 0.65),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: colors.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location == null
                            ? l.select_location
                            : location!.name == 'home'
                            ? l.home
                            : location!.name ?? l.selected_location,
                        style: Styles.textStyle14.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        location == null
                            ? l.choose_location_on_map
                            : location!.formattedAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.textStyle12.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  location == null ? l.select : l.change_location,
                  style: Styles.textStyle12.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
