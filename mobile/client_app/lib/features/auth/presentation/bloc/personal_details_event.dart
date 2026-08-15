part of 'personal_details_bloc.dart';

abstract class PersonalDetailsEvent extends Equatable {
  const PersonalDetailsEvent();

  @override
  List<Object?> get props => [];
}

class PersonalDetailsImagePicked extends PersonalDetailsEvent {
  const PersonalDetailsImagePicked();
}

class PersonalDetailsLocationChanged extends PersonalDetailsEvent {
  final SelectedMapLocation location;

  const PersonalDetailsLocationChanged(this.location);

  @override
  List<Object?> get props => [location];
}

class PersonalDetailsPhoneChanged extends PersonalDetailsEvent {
  final String phone;

  const PersonalDetailsPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class PersonalDetailsSubmitted extends PersonalDetailsEvent {
  const PersonalDetailsSubmitted();
}
