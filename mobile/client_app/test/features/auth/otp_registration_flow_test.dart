import 'dart:async';
import 'dart:io';

import 'package:client_app/features/auth/data/models/request/register_request_model.dart';
import 'package:client_app/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:client_app/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:client_app/features/auth/domain/entities/auth_entity.dart';
import 'package:client_app/features/auth/domain/entities/otp_dispatch_entity.dart';
import 'package:client_app/features/auth/domain/entities/user_entity.dart';
import 'package:client_app/features/auth/domain/entities/user_profile_entity.dart';
import 'package:client_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:client_app/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:client_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:client_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:client_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:client_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OTP registration request JSON', () {
    test('register omits password confirmation', () {
      const request = RegisterRequestModel(
        fullname: 'Qusai',
        email: 'qusai@example.com',
        password: 'Password123',
      );

      expect(request.toJson(), {
        'fullname': 'Qusai',
        'email': 'qusai@example.com',
        'password': 'Password123',
      });
    });

    test('verify uses the exact otp_code key', () {
      const request = VerifyOtpRequestModel(
        fullname: 'Qusai',
        email: 'qusai@example.com',
        password: 'Password123',
        otpCode: '674842',
      );

      expect(request.toJson(), {
        'fullname': 'Qusai',
        'email': 'qusai@example.com',
        'password': 'Password123',
        'otp_code': '674842',
      });
    });

    test('resend omits password', () {
      const request = ResendOtpRequestModel(
        fullname: 'Qusai',
        email: 'qusai@example.com',
      );

      expect(request.toJson(), {
        'fullname': 'Qusai',
        'email': 'qusai@example.com',
      });
    });
  });

  group('AuthBloc OTP flow', () {
    test(
      'register preserves pending data without creating auth state',
      () async {
        final repo = _FakeAuthRepo();
        final bloc = _buildBloc(repo);
        addTearDown(bloc.close);

        bloc.add(const Register('Qusai', 'qusai@example.com', 'Password123'));
        final state = await bloc.stream.firstWhere(
          (state) => state.status == AuthStatus.successRegister,
        );

        expect(state.token, isNull);
        expect(state.user, isNull);
        expect(state.pendingRegistration?.fullname, 'Qusai');
        expect(state.pendingRegistration?.email, 'qusai@example.com');
        expect(state.pendingRegistration?.password, 'Password123');
      },
    );

    test(
      'handled register success becomes initial without losing pending data',
      () async {
        final repo = _FakeAuthRepo();
        final bloc = _buildBloc(repo);
        addTearDown(bloc.close);

        bloc.add(const Register('Qusai', 'qusai@example.com', 'Password123'));
        await bloc.stream.firstWhere(
          (state) => state.status == AuthStatus.successRegister,
        );
        bloc.add(const AuthStatusHandled());
        final state = await bloc.stream.firstWhere(
          (state) => state.status == AuthStatus.initial,
        );

        expect(state.pendingRegistration, isNotNull);
        expect(state.successMessage, isNull);
      },
    );

    test(
      'register loading ends once and duplicate taps send one request',
      () async {
        final repo = _FakeAuthRepo();
        final bloc = _buildBloc(repo);
        addTearDown(bloc.close);
        repo.registerCompleter = Completer<OtpDispatchEntity>();

        bloc
          ..add(const Register('Qusai', 'qusai@example.com', 'Password123'))
          ..add(const Register('Qusai', 'qusai@example.com', 'Password123'));
        final loading = await bloc.stream.firstWhere(
          (state) => state.status == AuthStatus.loadingRegister,
        );

        expect(loading.isLoadingRegister, isTrue);
        expect(repo.registerCalls, 1);
        repo.registerCompleter!.complete(_FakeAuthRepo.otpSent);
        final success = await bloc.stream.firstWhere(
          (state) => state.status == AuthStatus.successRegister,
        );

        expect(success.isLoadingRegister, isFalse);
        expect(repo.registerCalls, 1);
      },
    );

    test('duplicate verify taps produce one in-flight request', () async {
      final repo = _FakeAuthRepo();
      final bloc = _buildBloc(repo);
      addTearDown(bloc.close);
      bloc.add(const Register('Qusai', 'qusai@example.com', 'Password123'));
      await bloc.stream.firstWhere(
        (state) => state.status == AuthStatus.successRegister,
      );

      repo.verifyCompleter = Completer<AuthEntity>();
      bloc
        ..add(const VerifyAccount('674842'))
        ..add(const VerifyAccount('674842'));
      await Future<void>.delayed(Duration.zero);

      expect(repo.verifyCalls, 1);
      repo.verifyCompleter!.complete(_FakeAuthRepo.auth);
      final state = await bloc.stream.firstWhere(
        (state) => state.status == AuthStatus.successVerifyAccount,
      );

      expect(state.pendingRegistration, isNull);
      expect(state.token, _FakeAuthRepo.auth.accessToken);
      expect(bloc.forms.registerPassword.text, isEmpty);
    });

    test(
      'duplicate resend taps produce one request and restart timer',
      () async {
        final repo = _FakeAuthRepo();
        final bloc = _buildBloc(repo);
        addTearDown(bloc.close);
        bloc.add(const Register('Qusai', 'qusai@example.com', 'Password123'));
        await bloc.stream.firstWhere(
          (state) => state.status == AuthStatus.successRegister,
        );
        bloc.add(const OtpCountdownStarted(seconds: 0));
        await bloc.stream.firstWhere(
          (state) => state.resendSecondsRemaining == 0,
        );

        repo.resendCompleter = Completer<OtpDispatchEntity>();
        bloc
          ..add(const RequestResendVerificationCode())
          ..add(const RequestResendVerificationCode());
        await Future<void>.delayed(Duration.zero);

        expect(repo.resendCalls, 1);
        repo.resendCompleter!.complete(_FakeAuthRepo.otpSent);
        final state = await bloc.stream.firstWhere(
          (state) => state.status == AuthStatus.successResendVerificationCode,
        );

        expect(state.resendSecondsRemaining, 60);
        expect(state.pendingRegistration, isNotNull);
      },
    );
  });
}

AuthBloc _buildBloc(AuthRepo repo) => AuthBloc(
  LoginUseCase(repo),
  RegisterUseCase(repo),
  VerifyOtpUseCase(repo),
  ResendOtpUseCase(repo),
  ChangePasswordUseCase(repo),
);

class _FakeAuthRepo implements AuthRepo {
  static const otpSent = OtpDispatchEntity(
    status: 210,
    message: 'OTP sent',
    email: 'qusai@example.com',
  );
  static const auth = AuthEntity(
    user: UserEntity(
      id: 109,
      fullname: 'Qusai',
      email: 'qusai@example.com',
      role: 'client',
    ),
    accessToken: 'test-access-token',
    status: 211,
    message: 'Client registered and verified successfully',
  );

  Completer<AuthEntity>? verifyCompleter;
  Completer<OtpDispatchEntity>? resendCompleter;
  Completer<OtpDispatchEntity>? registerCompleter;
  int registerCalls = 0;
  int verifyCalls = 0;
  int resendCalls = 0;

  @override
  Future<OtpDispatchEntity> register({
    required String fullname,
    required String email,
    required String password,
  }) {
    registerCalls++;
    return registerCompleter?.future ??
        Future<OtpDispatchEntity>.value(otpSent);
  }

  @override
  Future<AuthEntity> verifyOtp({
    required String fullname,
    required String email,
    required String password,
    required String otpCode,
  }) {
    verifyCalls++;
    return verifyCompleter?.future ?? Future<AuthEntity>.value(auth);
  }

  @override
  Future<OtpDispatchEntity> resendOtp({
    required String fullname,
    required String email,
  }) {
    resendCalls++;
    return resendCompleter?.future ?? Future<OtpDispatchEntity>.value(otpSent);
  }

  @override
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async => auth;

  @override
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async => 'Password changed';

  @override
  Future<UserProfileEntity> updateProfile({
    File? image,
    required double latitude,
    required double longitude,
    required String phone,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserProfileEntity> updateProfileWithAddress({
    File? image,
    required double latitude,
    required double longitude,
    required String address,
    required String phone,
  }) => updateProfile(
    image: image,
    latitude: latitude,
    longitude: longitude,
    phone: phone,
  );
}
