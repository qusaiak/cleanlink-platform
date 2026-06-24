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
  final String address;
  final String phone;
  final Failure? error;

  const PersonalDetailsState({
    this.status = PersonalDetailsStatus.initial,
    this.imagePath = '',
    this.address = '',
    this.phone = '',
    this.error,
  });

  PersonalDetailsState copyWith({
    PersonalDetailsStatus? status,
    String? imagePath,
    String? address,
    String? phone,
    Failure? error,
  }) {
    return PersonalDetailsState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, imagePath, address, phone, error];
}
