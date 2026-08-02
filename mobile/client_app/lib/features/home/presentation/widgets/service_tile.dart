import 'dart:ui';
import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/helper_functions.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';

class ServiceTile extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback? onTap;

  const ServiceTile({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: theme.primary.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CustomImageView(
                  // imagePath: Assets.images.test.test.path,
                  imagePath: service.image,
                  height: 110.w,
                  width: 110.w,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: SizedBox(
                  height: 115.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              service.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.textStyle14.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 11.sp,
                            color: theme.onSurfaceVariant,
                          ),

                          SizedBox(width: 2.w),

                          Text(
                            "${service.maxDuration.toString()} ${AppLocalizations.of(context)!.track_minutes_short}",
                            style: Styles.textStyle11.copyWith(
                              color: theme.onSurfaceVariant,
                            ),
                          ),

                          SizedBox(width: 12.w),

                          Text(
                            formatServicePriceRange(context, service),
                            style: Styles.textStyle11.copyWith(
                              color: theme.primary,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      CustomElevatedButton(
                        text: AppLocalizations.of(context)!.view_details,

                        buttonTextStyle: Styles.textStyle12.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),

                        buttonStyle: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            theme.primary,
                          ),
                        ),

                        onPressed: onTap,
                      ),
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
