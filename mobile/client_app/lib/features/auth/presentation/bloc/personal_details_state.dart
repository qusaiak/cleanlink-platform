part of 'personal_details_bloc.dart';

enum PersonalDetailsStatus {
  initial,
  pickingImage,
  imagePicked,
  imagePickError,
  loading,
  success,
  failure,
  validationError,
}

class PersonalDetailsState extends Equatable {
  final PersonalDetailsStatus status;
  final String imagePath;
  final SelectedMapLocation? location;
  final String phone;
  final Failure? error;

  const PersonalDetailsState({
    this.status = PersonalDetailsStatus.initial,
    this.imagePath = '',
    this.location,
    this.phone = '',
    this.error,
  });

  PersonalDetailsState copyWith({
    PersonalDetailsStatus? status,
    String? imagePath,
    SelectedMapLocation? location,
    String? phone,
    Failure? error,
  }) {
    return PersonalDetailsState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, imagePath, location, phone, error];
}
