part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ChangeThemeEvent extends ProfileEvent {}

class ChangeLanguageEvent extends ProfileEvent {}

class LoadProfileDataEvent extends ProfileEvent {}

class PickProfileImageEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String fullname;
  final String email;
  final String phone;
  final String address;

  const UpdateProfileEvent({
    required this.fullname,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [fullname, email, phone, address];
}

class LogoutEvent extends ProfileEvent {}
