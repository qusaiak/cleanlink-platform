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

class SelectProfileLocationEvent extends ProfileEvent {
  const SelectProfileLocationEvent(this.location);
  final SelectedMapLocation location;
  @override
  List<Object?> get props => [location];
}

class UpdateProfileEvent extends ProfileEvent {
  final String fullname;
  final String email;
  final String phone;

  const UpdateProfileEvent({
    required this.fullname,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [fullname, email, phone];
}

class LogoutEvent extends ProfileEvent {}

class GetDashboardSummaryEvent extends ProfileEvent {}

class RefreshProfileEvent extends ProfileEvent {}

class DeleteAccountEvent extends ProfileEvent {}

class ClearDeleteAccountResultEvent extends ProfileEvent {}

class LoadNotificationPreferenceEvent extends ProfileEvent {}

class SetNotificationPreferenceEvent extends ProfileEvent {
  const SetNotificationPreferenceEvent(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class OpenNotificationSettingsEvent extends ProfileEvent {}
