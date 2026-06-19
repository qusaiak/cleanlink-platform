import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:client_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'features/bookings/data/data_sources/bookings_api_service.dart';
import 'features/bookings/data/repositories/bookings_repo_impl.dart';
import 'features/bookings/domain/repositories/bookings_repo.dart';
import 'features/bookings/domain/usecases/get_bookings_usecase.dart';
import 'features/bookings/presentation/bloc/bookings_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // EXTERNAL
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);

  // Services
  sl.registerLazySingleton<BookingsApiService>(() => BookingsApiService(sl()));

  // Repositories
  sl.registerLazySingleton<BookingsRepo>(() => BookingsRepoImpl(sl()));

  // UseCases
  sl.registerLazySingleton<GetBookingsUseCase>(() => GetBookingsUseCase(sl()));

  // Blocs
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(() => BaseBloc());
  sl.registerFactory(() => ProfileBloc());

  sl.registerFactory(() => BookingsBloc(sl()));
}
