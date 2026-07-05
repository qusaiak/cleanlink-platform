import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/region_entity.dart';

class RegionCard extends StatelessWidget {
  const RegionCard({super.key, required this.region, this.onTap});

  final RegionEntity region;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Material(
      color: theme.surface,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                    child: CustomImageView(
                      imagePath: region.image,
                      height: 130.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      region.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle16.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 15.sp,
                          color: theme.onSurfaceVariant,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            region.manager!.fullname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle12.copyWith(
                              color: theme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.alternate_email,
                          size: 15.sp,
                          color: theme.onSurfaceVariant,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          region.manager!.email,
                          style: Styles.textStyle12.copyWith(
                            color: theme.onSurfaceVariant,
                          ),
                        ),
                      ],
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

  // Widget build(BuildContext context) {
  //   final theme = Theme.of(context).colorScheme;
  //   final manager = region.manager;
  //
  //   return Material(
  //     color: theme.surface,
  //     borderRadius: BorderRadius.circular(20.r),
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: BorderRadius.circular(20.r),
  //       child: Container(
  //         padding: EdgeInsets.all(14.w),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20.r),
  //           border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withValues(alpha: 0.05),
  //               blurRadius: 16,
  //               offset: const Offset(0, 6),
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 60.w,
  //               height: 60.w,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(16.r),
  //                 image: DecorationImage(image: NetworkImage(region.image!)),
  //               ),
  //             ),
  //             SizedBox(width: 14.w),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     region.name,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: Styles.textStyle16.copyWith(
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                   if (manager != null) ...[
  //                     SizedBox(height: 4.h),
  //                     Row(
  //                       children: [
  //                         Icon(
  //                           Icons.person_outline_rounded,
  //                           size: 14.sp,
  //                           color: theme.onSurfaceVariant,
  //                         ),
  //                         SizedBox(width: 4.w),
  //                         Expanded(
  //                           child: Text(
  //                             manager.fullname,
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                             style: Styles.textStyle12.copyWith(
  //                               color: theme.onSurface,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: 2.h),
  //                     Row(
  //                       children: [
  //                         Icon(
  //                           Icons.email_outlined,
  //                           size: 14.sp,
  //                           color: theme.onSurfaceVariant,
  //                         ),
  //                         SizedBox(width: 4.w),
  //                         Expanded(
  //                           child: Text(
  //                             manager.email,
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                             style: Styles.textStyle11.copyWith(
  //                               color: theme.onSurfaceVariant,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ],
  //               ),
  //             ),
  //             Icon(
  //               Icons.arrow_forward_ios_rounded,
  //               size: 15.sp,
  //               color: theme.primary,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
