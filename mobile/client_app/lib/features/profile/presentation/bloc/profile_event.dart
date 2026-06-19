part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ChangeThemeEvent extends ProfileEvent {}

class ChangeLanguageEvent extends ProfileEvent {}

