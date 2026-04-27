import 'package:client_app/features/auth/presentation/bloc/auth_form_controllers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
    : forms = AuthFormControllers(),
      super(
        const AuthState().copyWith(
          status: AuthStatus.initial,
          isPasswordVis: false,
          isOldPasswordVis: false,
          isNewPasswordVis: false,
          isConfirmPasswordVis: false,
          isLoadingLogin: false,
          isLoadingRegister: false,
        ),
      ) {
    on<Login>(onLogin);
    on<ChangePasswordView>(onChangePasswordView);
  }

  final AuthFormControllers forms;

  Future<void> onLogin(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loadingLogin));

    try {
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(status: AuthStatus.successLogin));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.errorLogin,
          error: const ServerFailure("Login failed", ""),
        ),
      );
    }
  }

  void onChangePasswordView(
    ChangePasswordView event,
    Emitter<AuthState> emit,
  ) async {
    if (event.currentTextFormField == 'login_password') {
      emit(
        state.copyWith(
          status: AuthStatus.changePassword,
          isPasswordVis: !state.isPasswordVis!,
        ),
      );
    } else if (event.currentTextFormField == 'old_password') {
      emit(
        state.copyWith(
          status: AuthStatus.changePassword,
          isOldPasswordVis: !state.isOldPasswordVis!,
        ),
      );
    } else if (event.currentTextFormField == 'new_password') {
      emit(
        state.copyWith(
          status: AuthStatus.changePassword,
          isNewPasswordVis: !state.isNewPasswordVis!,
        ),
      );
    } else if (event.currentTextFormField == 'confirm_password') {
      emit(
        state.copyWith(
          status: AuthStatus.changePassword,
          isConfirmPasswordVis: !state.isConfirmPasswordVis!,
        ),
      );
    }
  }
}
