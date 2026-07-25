part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class ChangeOnboardingIndicator extends OnboardingEvent {
  final int index;

  const ChangeOnboardingIndicator(this.index);

  @override
  List<Object> get props => [index];
}

class SkipEvent extends OnboardingEvent {
  const SkipEvent();

  @override
  List<Object?> get props => throw UnimplementedError();

}
