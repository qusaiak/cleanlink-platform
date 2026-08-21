import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'config/language/app_language_info.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme_info.dart';
import 'core/config/api_config.dart';
import 'core/network/http_headers.dart';
import 'core/network/network_info.dart';
import 'core/session/app_startup.dart';
import 'core/session/login_session.dart';
import 'features/auth/data/datasources/auth_api_service.dart';
import 'features/auth/data/repositories/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/data/datasources/worker_profile_remote_data_source.dart';
import 'features/profile/data/repositories/worker_profile_repository_impl.dart';
import 'features/profile/domain/repositories/worker_profile_repository.dart';
import 'features/profile/domain/usecases/attach_skills_usecase.dart';
import 'features/profile/domain/usecases/detach_skills_usecase.dart';
import 'features/profile/domain/usecases/get_skills_usecase.dart';
import 'features/profile/domain/usecases/get_worker_profile_usecase.dart';
import 'features/profile/domain/usecases/update_availability_usecase.dart';
import 'features/profile/domain/usecases/update_profile_image_usecase.dart';
import 'features/profile/domain/usecases/update_worker_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/worker_profile_bloc.dart';
import 'features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'features/tasks/data/repositories/tasks_repository_impl.dart';
import 'features/tasks/domain/repositories/tasks_repository.dart';
import 'features/tasks/domain/usecases/get_daily_tasks_usecase.dart';
import 'features/tasks/domain/usecases/get_task_by_id_usecase.dart';
import 'features/tasks/domain/usecases/get_today_task_summary_usecase.dart';
import 'features/tasks/domain/usecases/update_task_status_usecase.dart';
import 'features/tasks/domain/usecases/watch_daily_tasks_usecase.dart';
import 'features/tasks/presentation/bloc/tasks_bloc.dart';
import 'features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'features/notifications/data/repositories/notifications_repository_impl.dart';
import 'features/notifications/domain/repositories/notifications_repository.dart';
import 'features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';

final sl = GetIt.instance;

String? get authToken => LoginSession.token;

set authToken(String? value) => LoginSession.token = value;

const String kSkipAuthRedirect = 'skipAuthRedirect';

Future<void> clearSession() async {
  await LoginSession.clear();
  await sl.reset();
  await initializeDependencies();
}

Future<void> initializeDependencies() async {
  await AppLanguageInfo.initialize();

  await AppThemeInfo.initialize();
  await AppStartup.initialize();

  await LoginSession.restore();

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUsecase: sl(),
      authRepository: sl(),

      onTokenReceived: LoginSession.saveToken,
    ),
  );
  sl.registerFactory<ProfileBloc>(() => ProfileBloc());
  sl.registerFactory<TasksBloc>(
    () => TasksBloc(
      getDailyTasks: sl(),
      getTodayTaskSummary: sl(),
      updateTaskStatus: sl(),
      watchDailyTasks: sl(),
    ),
  );
  sl.registerFactory<WorkerProfileBloc>(
    () => WorkerProfileBloc(
      getProfile: sl(),
      updateAvailability: sl(),
      updateProfile: sl(),
      updateProfileImage: sl(),
      getSkills: sl(),
      attachSkills: sl(),
      detachSkills: sl(),

      getDailyTasks: sl(),
      watchDailyTasks: sl(),
    ),
  );
  sl.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(
      getNotifications: sl(),
      markRead: sl(),
      markAllRead: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthApiService>(() => AuthApiServiceImpl(sl()));

  sl.registerLazySingleton(() => GetDailyTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetTaskByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetTodayTaskSummaryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl()));
  sl.registerLazySingleton(() => WatchDailyTasksUseCase(sl()));

  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton(() => GetWorkerProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWorkerProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => GetSkillsUseCase(sl()));
  sl.registerLazySingleton(() => AttachSkillsUseCase(sl()));
  sl.registerLazySingleton(() => DetachSkillsUseCase(sl()));
  sl.registerLazySingleton<WorkerProfileRepository>(
    () =>
        WorkerProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<WorkerProfileRemoteDataSource>(
    () => WorkerProfileRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsReadUseCase(sl()));
  sl.registerLazySingleton<NotificationsRepository>(
    () =>
        NotificationsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton(() => _buildDio());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}

Dio _buildDio() {
  assert(
    ApiConfig.baseUrl.startsWith('http'),
    'API base URL is not configured: "${ApiConfig.baseUrl}"',
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.hostRoot,

      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        HttpHeader.accept.value: 'application/json',
        HttpHeader.contentType.value: 'application/json',
      },
      responseType: ResponseType.json,

      receiveDataWhenStatusError: true,

      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers[HttpHeader.acceptLanguage.value] =
            AppLanguageInfo.languageCode;

        final token = LoginSession.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          options.headers.remove('Authorization');
        }
        handler.next(options);
      },

      onError: (DioException err, handler) {
        final isUnauthorized = err.response?.statusCode == 401;
        final skipRedirect =
            err.requestOptions.extra[kSkipAuthRedirect] == true;

        if (isUnauthorized && !skipRedirect) {
          unawaited(LoginSession.clear());
          _goToLogin();
        }

        handler.next(err);
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
}

void _goToLogin() {
  try {
    if (AppRouter.router.state.fullPath == AppRouter.kLogin) return;
  } catch (_) {
    return;
  }
  AppRouter.router.go(AppRouter.kLogin);
}
