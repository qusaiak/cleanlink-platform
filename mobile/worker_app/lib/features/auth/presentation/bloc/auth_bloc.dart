import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/session/login_session.dart';
import '../../../../services/notification_service.dart';
import '../../../auth/domain/entities/login_client_entity.dart';
import '../../../auth/domain/repositories/auth_repo.dart';
import '../../../auth/domain/usecases/login_usecase.dart';
import 'auth_form_controllers.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final AuthRepository authRepository;

  final Future<void> Function(String token) onTokenReceived;

  AuthBloc({
    required this.loginUsecase,
    required this.authRepository,
    required this.onTokenReceived,
  }) : forms = AuthFormControllers(),
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
    on<ChangePasswordView>(onChangePasswordView);
    on<SubmitChangePassword>(onSubmitChangePassword);
  }

  final AuthFormControllers forms;

  bool _loginInFlight = false;

  Future<void> onLogin(Login event, Emitter<AuthState> emit) async {
    if (_loginInFlight) return;
    _loginInFlight = true;

    emit(state.copyWith(status: AuthStatus.loadingLogin, error: null));

    try {
      final result = await loginUsecase(
        params: LoginParams(email: event.email, password: event.password),
      );

      final entity = result.fold<LoginEntity?>((_) => null, (e) => e);
      if (entity == null) {
        emit(
          state.copyWith(
            status: AuthStatus.errorLogin,
            error: result.fold<Failure?>((f) => f, (_) => null),
          ),
        );
        return;
      }

      await onTokenReceived(entity.accessToken);
      await LoginSession.saveIdentity(
        employeeId: entity.id.toString(),
        role: entity.role,
        address: entity.address,
        phone: entity.phone,
      );

      final image = entity.profileImage;
      if (image != null && image.isNotEmpty) {
        await LoginSession.saveProfileImage(
          displayUrl: ApiUrlParameters.resolveImageUrl(image),
        );
      }

      unawaited(NotificationService.instance.registerToken());

      emit(
        state.copyWith(
          status: AuthStatus.successLogin,
          token: entity.accessToken,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.errorLogin,
          error: ServerFailure(e.toString(), ''),
        ),
      );
    } finally {
      _loginInFlight = false;
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

  Future<void> onSubmitChangePassword(
    SubmitChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loadingChangePassword, error: null));

    final result = await authRepository.changePassword(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
      newPasswordConfirmation: event.newPasswordConfirmation,
    );

    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      emit(
        state.copyWith(status: AuthStatus.errorChangePassword, error: failure),
      );
    } else {
      emit(state.copyWith(status: AuthStatus.successChangePassword));

      emit(state.copyWith(status: AuthStatus.changePassword));
    }
  }
}
