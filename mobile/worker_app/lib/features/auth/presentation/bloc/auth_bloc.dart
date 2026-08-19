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

  /// Persists the bearer token. Async and AWAITED (see [onLogin]) so the token
  /// is stored before login is reported as successful.
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

  /// Guards against a second login request while one is already in flight.
  ///
  /// The button disables itself on `loadingLogin`, but that only takes effect
  /// after the state has been emitted and the frame rebuilt — a fast double tap
  /// (or the event being added from both a submit callback and a listener) can
  /// still enqueue two [Login] events. Two concurrent logins mint two tokens on
  /// the server and the slower response overwrites the faster one, which is a
  /// perfectly good way to end up "logged in" with a token the app then treats
  /// as stale.
  bool _loginInFlight = false;

  Future<void> onLogin(Login event, Emitter<AuthState> emit) async {
    if (_loginInFlight) return;
    _loginInFlight = true;

    // Each attempt starts from a clean slate: the previous failure is dropped
    // here (see [AuthState.copyWith], where `error` is now transient) so a
    // retry can never render the old message, and the eventual success state
    // can't carry a failure with it.
    emit(state.copyWith(status: AuthStatus.loadingLogin, error: null));

    try {
      final result = await loginUsecase(
        params: LoginParams(email: event.email, password: event.password),
      );

      // dartz's `fold` cannot await, so the value is unwrapped here instead:
      // every step below really does complete before the success state (and the
      // navigation it triggers) is emitted.
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

      // 1) Persist the session BEFORE anything else. Both awaits complete
      //    before `successLogin` is emitted, and `successLogin` is what makes
      //    the screen navigate to Home — so by the time any screen behind that
      //    route issues its first authenticated request, the token the
      //    interceptor reads is already in place.
      await onTokenReceived(entity.accessToken);
      await LoginSession.saveIdentity(
        employeeId: entity.id.toString(),
        address: entity.address,
        phone: entity.phone,
      );
      // The avatar the login response already knows about, so the top bar and
      // drawer render the right picture before the profile fetch returns. Only
      // the display url is cached — the login payload carries a public URL, not
      // the `storage\...` path that `update-image` expects.
      final image = entity.profileImage;
      if (image != null && image.isNotEmpty) {
        await LoginSession.saveProfileImage(
          displayUrl: ApiUrlParameters.resolveImageUrl(image),
        );
      }

      // 2) Only now the background work. Deliberately NOT awaited — on a first
      //    run FCM has to register the device before it can hand out a token,
      //    which can take seconds; login must never wait on it, and (see the
      //    interceptor) its failure must never move the worker off the screen.
      unawaited(NotificationService.instance.registerToken());

      // 3) Navigation trigger, last.
      emit(
        state.copyWith(
          status: AuthStatus.successLogin,
          token: entity.accessToken,
        ),
      );
    } catch (e) {
      // Nothing may escape an event handler: an uncaught error here leaves the
      // state on `loadingLogin` forever, with the button permanently disabled
      // and no message — the "it just stops responding" failure mode.
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

  /// Submits the change-password form. Emits loading → success/error, carrying
  /// the server's own failure message on error (the repository maps
  /// `DioException` → `Failure` with the body's `message`).
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
      // Reset to the visual-toggle status so the screen doesn't stay on
      // "success" forever (which would re-show the success snackbar on rebuild).
      emit(state.copyWith(status: AuthStatus.changePassword));
    }
  }
}
