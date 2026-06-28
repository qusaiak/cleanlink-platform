import 'package:client_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/storage/shared_storage.dart';
import '../../../../core/storage/storage_data.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_dots_indicator.dart';
import '../../../../l10n/app_localizations.dart';
import 'intro_view.dart';
import 'move_next_page.dart';
import 'onboarding_widgets.dart';

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    List<Onboarding> contents = [
      Onboarding(
        0,
        AppLocalizations.of(context)!.help_text_1,
        Assets.images.onboarding.introImage1.path,
      ),
      Onboarding(
        1,
        AppLocalizations.of(context)!.help_text_2,
        Assets.images.onboarding.introImage2.path,
      ),
      Onboarding(
        2,
        AppLocalizations.of(context)!.help_text_3,
        Assets.images.onboarding.introImage3.path,
      ),
    ];

    for (var content in contents) {
      precacheImage(AssetImage(content.imageUrl), context);
    }

    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Stack(
            children: [
              PageView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: state.pageController,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  context.read<OnboardingBloc>().add(
                    ChangeOnboardingIndicator(index),
                  );
                },
                itemBuilder: (_, i) {
                  return IntroView(contents[i].title, contents[i].imageUrl);
                },
              ),
              const SkipButton(),
              Positioned(
                left: 20.w,
                bottom: 35.h,
                child: CustomDotsIndicator(
                  currentIndex: state.current!,
                  contents: contents,
                  onDotTap: (index) {
                    state.pageController!.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  selectedWidth: 25.w,
                  width: 10.w,
                  height: 10.h,
                  spaceBetweenDots: 8.w,
                ),
              ),
              MoveNextPage(
                onTap: () async {
                  if (state.current == 2) {
                    await SharedStorage.set(
                      StorageData.isOnboarding,
                      "true",
                    );
                    router.go(AppRouter.kLogin);
                  } else {
                    state.pageController!.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class Onboarding {
  final int id;
  final String title;
  final String imageUrl;

  Onboarding(this.id, this.title, this.imageUrl);
}
