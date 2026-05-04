import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:client_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerFactory<AuthBloc>(() => AuthBloc());
  sl.registerFactory<BaseBloc>(() => BaseBloc());
  sl.registerFactory<ProfileBloc>(() => ProfileBloc());

  /// =========================
  /// EXTERNAL
  /// =========================
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}
