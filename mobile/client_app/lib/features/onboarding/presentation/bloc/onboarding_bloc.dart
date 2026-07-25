import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc()
    : super(OnboardingInitial(0, PageController(initialPage: 0))) {
    on<ChangeOnboardingIndicator>(onChangeOnboardingIndicator);
    on<SkipEvent>(onSkipEvent);
  }

  void onChangeOnboardingIndicator(
    ChangeOnboardingIndicator event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingChangeDots(event.index, state.pageController!));
  }

  void onSkipEvent(SkipEvent event, Emitter<OnboardingState> emit) {
    emit(SkipState(2, state.pageController!));
  }

  @override
  Future<void> close() {
    state.pageController!.dispose();
    return super.close();
  }
}
