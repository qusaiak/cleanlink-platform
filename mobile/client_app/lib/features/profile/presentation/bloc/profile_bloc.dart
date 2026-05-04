import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/language/app_language_info.dart';
import '../../../../config/theme/app_theme_info.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc()
      : super(
    ProfileState(
      status: ProfileStatus.initial,
      isLight: AppThemeInfo.isLight,
      languageCode: AppLanguageInfo.languageCode,
    ),
  ) {
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onChangeTheme(
      ChangeThemeEvent event,
      Emitter<ProfileState> emit,
      ) async {
    await AppThemeInfo.toggleTheme();

    emit(
      state.copyWith(
        status: ProfileStatus.changeTheme,
        isLight: AppThemeInfo.isLight,
      ),
    );
  }

  Future<void> _onChangeLanguage(
      ChangeLanguageEvent event,
      Emitter<ProfileState> emit,
      ) async {
    String languageCode = AppLanguageInfo.languageCode;

    languageCode = languageCode == "en" ? "ar" : "en";

    await AppLanguageInfo.setLanguageCode(languageCode);

    // sl<ClientWrapper>().updateHeader(
    //   HttpHeader.acceptLanguage,
    //   languageCode.toUpperCase(),
    // );

    emit(
      state.copyWith(
        status: ProfileStatus.changeLanguage,
        languageCode: languageCode,
      ),
    );
  }

}