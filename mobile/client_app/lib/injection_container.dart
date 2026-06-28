import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:client_app/features/categories/data/data_sources/categories_api_service.dart';
import 'package:client_app/features/categories/data/repositories/categories_repo_impl.dart';
import 'package:client_app/features/categories/domain/repositories/categories_repo.dart';
import 'package:client_app/features/categories/domain/usecases/get_categoris_usecase.dart';
import 'package:client_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:client_app/features/companies/data/data_sources/companies_api_service.dart';
import 'package:client_app/features/companies/data/repositories/companies_repo_impl.dart';
import 'package:client_app/features/companies/domain/usecases/get_companies_usecase.dart';
import 'package:client_app/features/companies/domain/usecases/get_company_details_use_case.dart';
import 'package:client_app/features/home/data/data_sources/home_api_service.dart';
import 'package:client_app/features/home/data/repositories/home_repo_impl.dart';
import 'package:client_app/features/home/domain/repositories/home_repo.dart';
import 'package:client_app/features/home/domain/usecases/home_usecase.dart';
import 'package:client_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:client_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:client_app/features/services/data/data_sources/services_api_service.dart';
import 'package:client_app/features/services/data/repositories/services_repo_impl.dart';
import 'package:client_app/features/services/domain/repositories/services_repo.dart';
import 'package:client_app/features/services/domain/usecases/get_service_details_use_case.dart';
import 'package:client_app/features/services/domain/usecases/get_services_usecase.dart';
import 'package:client_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'core/network/dio_factory.dart';
import 'core/session/user_session.dart';
import 'features/auth/data/data_sources/auth_api_service.dart';
import 'features/auth/data/repositories/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/update_profile_usecase.dart';
import 'features/auth/presentation/bloc/personal_details_bloc.dart';
import 'features/bookings/data/data_sources/bookings_api_service.dart';
import 'features/bookings/data/repositories/bookings_repo_impl.dart';
import 'features/bookings/domain/repositories/bookings_repo.dart';
import 'features/bookings/domain/usecases/get_bookings_usecase.dart';
import 'features/bookings/presentation/bloc/bookings_bloc.dart';
import 'features/companies/domain/repositories/companies_repo.dart';
import 'features/companies/presentation/bloc/companies_bloc.dart';
import 'features/track_service/data/data_sources/track_service_api_service.dart';
import 'features/track_service/data/repositories/track_service_repo_impl.dart';
import 'features/track_service/domain/repositories/track_service_repo.dart';
import 'features/track_service/domain/usecases/cancel_service_usecase.dart';
import 'features/track_service/domain/usecases/track_service_usecase.dart';
import 'features/track_service/presentation/bloc/track_service_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // EXTERNAL
  sl.registerLazySingleton<Dio>(() => DioFactory.createDio());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
  sl.registerLazySingleton(() => ImagePicker());

  // Session
  sl.registerLazySingleton<UserSession>(() => UserSession());

  // Services
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));
  sl.registerLazySingleton<HomeApiService>(() => HomeApiService(sl()));
  sl.registerLazySingleton<CompaniesApiService>(
    () => CompaniesApiService(sl()),
  );
  sl.registerLazySingleton<CategoriesApiService>(
    () => CategoriesApiService(sl()),
  );
  sl.registerLazySingleton<ServicesApiService>(() => ServicesApiService(sl()));
  sl.registerLazySingleton<BookingsApiService>(() => BookingsApiService(sl()));
  sl.registerLazySingleton<TrackServiceApiService>(
    () => TrackServiceApiService(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl(), sl()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));
  sl.registerLazySingleton<CompaniesRepo>(() => CompaniesRepoImpl(sl()));
  sl.registerLazySingleton<CategoriesRepo>(() => CategoriesRepoImpl(sl()));
  sl.registerLazySingleton<ServicesRepo>(() => ServicesRepoImpl(sl()));
  sl.registerLazySingleton<BookingsRepo>(() => BookingsRepoImpl(sl()));
  sl.registerLazySingleton<TrackServiceRepo>(() => TrackServiceRepoImpl(sl()));

  // UseCases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl()),
  );
  sl.registerLazySingleton<GetHomeUseCase>(() => GetHomeUseCase(sl()));
  sl.registerLazySingleton<GetCompaniesUseCase>(
    () => GetCompaniesUseCase(sl()),
  );
  sl.registerLazySingleton<GetCompanyDetailsUseCase>(
    () => GetCompanyDetailsUseCase(sl()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl()),
  );
  sl.registerLazySingleton<GetServicesUseCase>(() => GetServicesUseCase(sl()));
  sl.registerLazySingleton<GetServiceDetailsUseCase>(
    () => GetServiceDetailsUseCase(sl()),
  );
  sl.registerLazySingleton<GetBookingsUseCase>(() => GetBookingsUseCase(sl()));
  sl.registerLazySingleton<TrackServiceUseCase>(
    () => TrackServiceUseCase(sl()),
  );
  sl.registerLazySingleton<CancelServiceUseCase>(
    () => CancelServiceUseCase(sl()),
  );

  // Blocs
  sl.registerFactory(() => BaseBloc());
  sl.registerFactory(() => AuthBloc(sl(), sl()));
  sl.registerFactory(() => ProfileBloc());
  sl.registerFactory(() => HomeBloc(sl()));
  sl.registerFactory(() => CompaniesBloc(sl(), sl()));
  sl.registerFactory(() => CategoriesBloc(sl()));
  sl.registerFactory(() => ServicesBloc(sl(), sl()));
  sl.registerFactory(() => PersonalDetailsBloc(sl(), sl(), sl()));

  sl.registerFactory(() => BookingsBloc(sl()));
  sl.registerFactory(() => TrackServiceBloc(sl(), sl()));
}
