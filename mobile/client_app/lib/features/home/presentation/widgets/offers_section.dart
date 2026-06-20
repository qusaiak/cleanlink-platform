import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client_app/features/home/data/models/offer_model.dart';
import 'package:client_app/features/home/presentation/widgets/offer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/utils/gen/assets.gen.dart';

class OffersSection extends StatefulWidget {
  const OffersSection({super.key});

  @override
  State<OffersSection> createState() => _OffersSectionState();
}

class _OffersSectionState extends State<OffersSection> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  static final offers = [
    OfferModel(
      title: '20% Off Deep Cleaning',
      subtitle: 'First booking discount',
      image: Assets.images.test.test.path,
    ),
    OfferModel(
      title: 'Home Cleaning Experts',
      subtitle: 'Trusted professionals',
      image: Assets.images.test.test.path,
    ),
    OfferModel(
      title: 'Fast Booking',
      subtitle: 'Book in seconds',
      image: Assets.images.test.test.path,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    for (final offer in offers) {
      precacheImage(AssetImage(offer.image), context);
    }
  }

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
          itemCount: offers.length,
          itemBuilder: (_, index, __) {
            return ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (_, currentIndex, __) {
                return OfferCard(
                  offer: offers[index],
                  isActive: currentIndex == index,
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
            return _DotsIndicator(count: offers.length, index: currentIndex);
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
