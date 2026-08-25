import 'package:carousel_slider/carousel_slider.dart';
import 'package:client_app/core/widgets/custom_image_view.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/row_title.dart';
import '../../domain/entities/company_entity.dart';
import '../bloc/companies_bloc.dart';

class ExpertsSection extends StatefulWidget {
  final CompanyEntity company;

  const ExpertsSection({super.key, required this.company});

  @override
  State<ExpertsSection> createState() => _ExpertsSectionState();
}

class _ExpertsSectionState extends State<ExpertsSection> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  // static final experts = [
  //   {
  //     "name": "Ahmed",
  //     "exp": "5 yrs exp",
  //     "image": Assets.images.test.worker.path,
  //   },
  //   {
  //     "name": "Omar",
  //     "exp": "8 yrs exp",
  //     "image": Assets.images.test.worker.path,
  //   },
  //   {
  //     "name": "Sara",
  //     "exp": "3 yrs exp",
  //     "image": Assets.images.test.worker.path,
  //   },
  // ];

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   for (final expert in widget.company.workers) {
  //     precacheImage(AssetImage(Assets.images.test.worker.path), context);
  //   }
  // }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompaniesBloc, CompaniesState>(
      builder: (context, state) {
        return Column(
          children: [
            RowTitle(
              iconData: Icons.people_alt_outlined,
              title: AppLocalizations.of(context)!.meet_our_workers,
            ),

            SizedBox(height: 12.h),

            CarouselSlider.builder(
              itemCount: widget.company.workers.length,
              itemBuilder: (context, index, realIndex) {
                final worker = widget.company.workers[index];

                return ValueListenableBuilder<int>(
                  valueListenable: _currentIndex,
                  builder: (context, currentIndex, _) {
                    return _WorkerCard(
                      image:
                          worker.user.profile!.image ??
                          Assets.images.test.test.path,
                      name: worker.user.fullname,
                      exp: worker.experienceYears.toString(),
                      isActive: index == currentIndex,
                    );
                  },
                );
              },
              options: CarouselOptions(
                height: 220.h,
                viewportFraction: 0.6,
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
              builder: (context, currentIndex, _) {
                return _DotsIndicator(
                  count: widget.company.workers.length,
                  index: currentIndex,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _WorkerCard extends StatelessWidget {
  const _WorkerCard({
    required this.image,
    required this.name,
    required this.exp,
    required this.isActive,
  });

  final String image;
  final String name;
  final String exp;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: isActive ? 0 : 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isActive ? 0.25 : 0.1),
            blurRadius: isActive ? 15 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomImageView(imagePath: image, fit: BoxFit.cover),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    "${AppLocalizations.of(context)!.years_of_experience}: $exp",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
