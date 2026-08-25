import 'package:client_app/config/theme/colors.dart';
import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/core/widgets/custom_image_view.dart';
import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.isActive,
    this.onTap,
  });

  final ServiceEntity offer;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
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
                              offer.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.textStyle16.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4.h),

                            Text(
                              offer.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.textStyle12.copyWith(
                                color: Colors.white70,
                              ),
                            ),

                            SizedBox(height: 8.h),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 18.w,
                child: DiscountCurtain(discount: offer.discount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiscountCurtain extends StatelessWidget {
  const DiscountCurtain({super.key, required this.discount});

  final num discount;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurtainClipper(),
      child: Container(
        width: 60.w,
        height: 50.h,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.primaryColor, AppColor.secondaryColor],
          ),
        ),

        child: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Text(
            "-${discount.toInt()}%",
            style: Styles.textStyle16.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class CurtainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const waveHeight = 8.0;

    path.moveTo(0, 0);

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height - waveHeight);

    final section = size.width / 3;

    path.quadraticBezierTo(
      section * 2.5,
      size.height,
      section * 2,
      size.height - waveHeight,
    );

    path.quadraticBezierTo(
      section * 1.5,
      size.height,
      section,
      size.height - waveHeight,
    );

    path.quadraticBezierTo(
      section * 0.5,
      size.height,
      0,
      size.height - waveHeight,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
