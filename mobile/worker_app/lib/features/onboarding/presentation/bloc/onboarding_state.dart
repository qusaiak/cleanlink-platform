part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {

  final int? current;

  final PageController? pageController;

  const OnboardingState({this.current,this.pageController});

  @override
  List<Object?> get props =>
      [current, pageController];
}

class OnboardingInitial extends OnboardingState {

  const OnboardingInitial(int current, PageController pageController)
      : super(current: current, pageController: pageController);

}

class OnboardingChangeDots extends OnboardingState {
  const OnboardingChangeDots(int current, PageController pageController)
      : super(current: current, pageController: pageController);
}

class SkipState extends OnboardingState {
  const SkipState(int current, PageController pageController)
      : super(current: current, pageController: pageController);
}