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
          padding: EdgeInsets.zero,
        ),

        SizedBox(height: 12.h),

        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth
                .clamp(280.0, 420.0)
                .toDouble();

            return SizedBox(
              height: 220.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) => SizedBox(width: 14.w),
                itemBuilder: (context, index) {
                  final item = images[index];

                  return Container(
                    width: cardWidth,
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
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
                                child: _GalleryImage(
                                  imageUrl: item.imageBefore,
                                  label: AppLocalizations.of(
                                    context,
                                  )!.before_label,
                                ),
                              ),

                              Container(
                                width: 1.5.w,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),

                              Expanded(
                                child: _GalleryImage(
                                  imageUrl: item.imageAfter,
                                  label: AppLocalizations.of(
                                    context,
                                  )!.after_label,
                                ),
                              ),
                            ],
                          ),

                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.7),
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
            );
          },
        ),
      ],
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.imageUrl, required this.label});

  final String imageUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: CustomImageView(
            imagePath: imageUrl,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        PositionedDirectional(
          start: 10.w,
          bottom: 10.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
