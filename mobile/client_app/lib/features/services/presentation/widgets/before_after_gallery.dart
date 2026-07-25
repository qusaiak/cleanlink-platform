import 'package:client_app/core/widgets/custom_image_view.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/row_title.dart';
import '../../domain/entities/service_gallery_image_entity.dart';

class BeforeAfterGallery extends StatelessWidget {
  const BeforeAfterGallery({super.key, required this.images});

  final List<ServiceGalleryImageEntity> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox();
    }

    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowTitle(
          iconData: Icons.compare_arrows_rounded,
          title: AppLocalizations.of(context)!.before_and_after,
          onTap: () {},
          padding: EdgeInsets.zero,
        ),

        SizedBox(height: 12.h),

        SizedBox(
          height: 180.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              final item = images[index];

              return Container(
                width: 300.w,
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _GalleryImage(imageUrl: item.imageBefore),
                          ),

                          Container(
                            width: 1.5.w,
                            color: Colors.white.withOpacity(0.9),
                          ),

                          Expanded(
                            child: _GalleryImage(imageUrl: item.imageAfter),
                          ),
                        ],
                      ),

                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.7),
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 12.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              color: theme.primary,
                              shape: BoxShape.circle,
                              border: BoxBorder.all(
                                width: 1.2,
                                color: Colors.white,
                              ),
                            ),
                            child: Icon(
                              Icons.compare_arrows_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CustomImageView(
      imagePath: imageUrl,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
