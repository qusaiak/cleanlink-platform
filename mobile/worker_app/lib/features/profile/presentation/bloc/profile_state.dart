part of 'profile_bloc.dart';

enum ProfileStatus { initial, changeTheme, changeLanguage }

class ProfileState {
  final ProfileStatus status;
  final bool isLight;
  final String languageCode;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.isLight = true,
    this.languageCode = "en",
  });

  ProfileState copyWith({
    ProfileStatus? status,
    bool? isLight,
    String? languageCode,
  }) {
    return ProfileState(
      status: status ?? this.status,
      isLight: isLight ?? this.isLight,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [status, isLight, languageCode];
}
