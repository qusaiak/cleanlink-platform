import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/core/widgets/custom_elevated_button.dart';
import 'package:client_app/core/widgets/custom_image_view.dart';
import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/gen/assets.gen.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer, required this.isActive});

  final ServiceEntity offer;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: isActive ? 0 : 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isActive ? 0.25 : 0.10),
            blurRadius: isActive ? 15 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomImageView(
              // imagePath: Assets.images.test.test.path,
              imagePath: offer.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(18.w),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.nameEn,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle16.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            offer.descriptionEn,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle12.copyWith(
                              color: Colors.white70,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          SizedBox(
                            height: 34.h,
                            width: 120.w,
                            child: CustomElevatedButton(
                              text: AppLocalizations.of(context)!.book_now,

                              buttonTextStyle: Styles.textStyle12.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),

                              buttonStyle: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  theme.primary,
                                ),
                              ),

                              onPressed: () {},
                            ),

                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
