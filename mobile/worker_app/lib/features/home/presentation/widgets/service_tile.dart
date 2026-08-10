import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/service_model.dart';

class ServiceTile extends StatelessWidget {
  final ServiceModel service;

  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: AppRadius.card,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: theme.surfaceContainer.withValues(alpha: 0.55),
            borderRadius: AppRadius.card,
            border: Border.all(color: theme.primary.withValues(alpha: 0.5), width: 1),
            boxShadow: AppShadow.card(Theme.of(context).brightness),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: CustomImageView(
                  imagePath: service.image,
                  height: 110.w,
                  width: 110.w,
                  fit: BoxFit.cover,
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
                            service.title,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle14.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.onSurface,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.favorite_border,
                          size: 20.sp,
                          color: theme.primary,
                        ),
                      ],
                    ),

                    Text(
                      service.company,
                      style: Styles.textStyle12.copyWith(
                        color: theme.onSurfaceVariant,
                      ),
                    ),

                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 11.sp,
                              color: theme.onSurfaceVariant,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              service.duration,
                              style: Styles.textStyle11.copyWith(
                                color: theme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 12.w),

                        Text(
                          service.price,
                          style: Styles.textStyle11.copyWith(
                            color: theme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 7.h),

                    CustomElevatedButton(
                      text: AppLocalizations.of(context)!.book_now,
                      buttonTextStyle: Styles.textStyle12.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.button,
                        ),
                      ),
                      onPressed: () {},
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
