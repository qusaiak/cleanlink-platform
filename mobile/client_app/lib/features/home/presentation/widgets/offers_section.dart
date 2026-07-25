import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client_app/features/home/presentation/widgets/offer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../services/domain/entities/service_entity.dart';

class OffersSection extends StatefulWidget {
  final List<ServiceEntity> offers;
  const OffersSection({super.key, required this.offers});

  @override
  State<OffersSection> createState() => _OffersSectionState();
}

class _OffersSectionState extends State<OffersSection> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.offers.length,
          itemBuilder: (_, index, __) {
            return ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (_, currentIndex, __) {
                return OfferCard(
                  offer: widget.offers[index],
                  isActive: currentIndex == index,
                  onTap: () {
                    GoRouter.of(context)!.push(
                      AppRouter.kServiceDetails,
                      extra: widget.offers[index].id,
                    );
                  },
                );
              },
            );
          },
          options: CarouselOptions(
            height: 180.h,
            viewportFraction: 0.86,

            enlargeCenterPage: true,

            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 1200),
            autoPlayCurve: Curves.fastOutSlowIn,

            pauseAutoPlayOnTouch: true,
            pauseAutoPlayOnManualNavigate: true,

            onPageChanged: (index, reason) {
              _currentIndex.value = index;
            },
          ),
        ),

        SizedBox(height: 14.h),

        ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (_, currentIndex, __) {
            return _DotsIndicator(
              count: widget.offers.length,
              index: currentIndex,
            );
          },
        ),
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 18.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive ? AppColor.primaryColor : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20.r),
          ),
        );
      }),
    );
  }
}
