import 'package:client_app/features/auth/presentation/bloc/auth_form_controllers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  AuthBloc(this._loginUseCase, this._registerUseCase)
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
          isVerifyAccountLoading: false,
          isRequestResendVerificationCodeLoading: false,
        ),
      ) {
    on<Login>(onLogin);
    on<Register>(onRegister);
    on<ChangePasswordView>(onChangePasswordView);
  }

  final AuthFormControllers forms;

  Future<void> onLogin(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loadingLogin));

    try {
      final auth = await _loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );

      emit(
        state.copyWith(
          status: AuthStatus.successLogin,
          token: auth.accessToken,
          user: auth.user,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(status: AuthStatus.errorLogin, error: failure));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.errorLogin,
          error: const ServerFailure("Login failed", ""),
        ),
      );
    }
  }

  Future<void> onRegister(Register event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loadingRegister));

    try {
      final auth = await _registerUseCase(
        RegisterParams(
          fullname: event.userName,
          email: event.email,
          password: event.password,
        ),
      );

      emit(
        state.copyWith(
          status: AuthStatus.successRegister,
          token: auth.accessToken,
          user: auth.user,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(status: AuthStatus.errorRegister, error: failure));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.errorRegister,
          error: const ServerFailure("Registration failed", ""),
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
