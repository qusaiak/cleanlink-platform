part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  changeTheme,
  changeLanguage,
  loadingProfile,
  profileLoaded,
  pickingImage,
  imagePicked,
  updatingProfile,
  updateSuccess,
  loggingOut,
  logoutSuccess,
  validationError,
  failure,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final bool isLight;
  final String languageCode;
  final String fullname;
  final String email;
  final String phone;
  final String address;
  final String image;
  final File? imageFile;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;

  bool get isLoadingProfile => status == ProfileStatus.loadingProfile;
  bool get isUpdatingProfile => status == ProfileStatus.updatingProfile;
  bool get isLoggingOut => status == ProfileStatus.loggingOut;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.isLight = true,
    this.languageCode = "en",
    this.fullname = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.image = '',
    this.imageFile,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    bool? isLight,
    String? languageCode,
    String? fullname,
    String? email,
    String? phone,
    String? address,
    String? image,
    File? imageFile,
    bool clearImageFile = false,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      isLight: isLight ?? this.isLight,
      languageCode: languageCode ?? this.languageCode,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      image: image ?? this.image,
      imageFile: clearImageFile ? null : imageFile ?? this.imageFile,
      user: user ?? this.user,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isLight,
    languageCode,
    fullname,
    email,
    phone,
    address,
    image,
    imageFile?.path,
    user,
    errorMessage,
    successMessage,
  ];
}
