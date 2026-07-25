
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'config/constants/api_url_parameters.dart';
import 'config/language/app_language_info.dart';
import 'core/network/http_headers.dart';
import 'core/network/network_info.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/data/datasources/fake_worker_profile_remote_data_source.dart';
import 'features/profile/data/datasources/fallback_worker_profile_remote_data_source.dart';
import 'features/profile/data/datasources/worker_profile_remote_data_source.dart';
import 'features/profile/data/repositories/worker_profile_repository_impl.dart';
import 'features/profile/domain/repositories/worker_profile_repository.dart';
import 'features/profile/domain/usecases/get_worker_profile_usecase.dart';
import 'features/profile/domain/usecases/update_availability_usecase.dart';
import 'features/profile/domain/usecases/update_worker_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/worker_profile_bloc.dart';
import 'features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'features/tasks/data/datasources/fallback_tasks_remote_data_source.dart';
import 'features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'features/tasks/data/repositories/tasks_repository_impl.dart';
import 'features/tasks/domain/repositories/tasks_repository.dart';
import 'features/tasks/domain/usecases/get_daily_tasks_usecase.dart';
import 'features/tasks/domain/usecases/get_task_by_id_usecase.dart';
import 'features/tasks/domain/usecases/update_task_status_usecase.dart';
import 'features/tasks/domain/usecases/upload_task_photos_usecase.dart';
import 'features/tasks/presentation/bloc/tasks_bloc.dart';
import 'features/notifications/data/datasources/fake_notifications_remote_data_source.dart';
import 'features/notifications/data/datasources/fallback_notifications_remote_data_source.dart';
import 'features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'features/notifications/data/repositories/notifications_repository_impl.dart';
import 'features/notifications/domain/repositories/notifications_repository.dart';
import 'features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/search/data/datasources/fake_search_remote_data_source.dart';
import 'features/search/data/datasources/fallback_search_remote_data_source.dart';
import 'features/search/data/datasources/search_remote_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/search_services_usecase.dart';
import 'features/search/presentation/bloc/search_bloc.dart';

final sl = GetIt.instance;

/// Master switch for how feature data is sourced.
///
/// `true`  → ONLY in-memory fake data sources; the network is never touched
///           (handy for pure UI work).
/// `false` → live-with-fallback: every feature tries the real Dio-backed source
///           first (GET/POST against [ApiUrlParameters.baseUrl] → the backend's
///           database) and, whenever the server is unreachable, transparently
///           falls back to the in-memory data — so the data stays as it is
///           today until the backend is actually running.
///
/// Default `false`: the app pulls live data from the database when the backend
/// is up and reachable, and otherwise shows the current data unchanged. Set the
/// real base URL in [ApiUrlParameters.baseUrl] (and an [authToken] after login)
/// to point it at production.
const bool kUseMockData = false;

/// Bearer token sent with authenticated requests. Set this after login
/// (e.g. from the auth flow); when null no Authorization header is sent.
String? authToken;

Future<void> initializeDependencies() async {
  /// =========================
  /// BLOCS
  /// =========================
  sl.registerFactory<AuthBloc>(() => AuthBloc());
  sl.registerFactory<ProfileBloc>(() => ProfileBloc());
  sl.registerFactory<TasksBloc>(
    () => TasksBloc(getDailyTasks: sl(), updateTaskStatus: sl()),
  );
  sl.registerFactory<WorkerProfileBloc>(
    () => WorkerProfileBloc(
      getProfile: sl(),
      updateAvailability: sl(),
      updateProfile: sl(),
    ),
  );
  sl.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(
      getNotifications: sl(),
      markRead: sl(),
      markAllRead: sl(),
    ),
  );
  sl.registerFactory<SearchBloc>(() => SearchBloc(searchServices: sl()));

  /// =========================
  /// TASKS FEATURE
  /// =========================
  sl.registerLazySingleton(() => GetDailyTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetTaskByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl()));
  sl.registerLazySingleton(() => UploadTaskPhotosUseCase(sl()));

  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Pure mock when [kUseMockData]; otherwise live-with-fallback (real Dio data
  // straight from the backend/database, in-memory data when it's unreachable).
  // Singleton so the in-memory edits persist for the session.
  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => kUseMockData
        ? FakeTasksRemoteDataSource()
        : FallbackTasksRemoteDataSource(
            primary: TasksRemoteDataSourceImpl(sl()),
            fallback: FakeTasksRemoteDataSource(),
          ),
  );

  /// =========================
  /// WORKER PROFILE FEATURE
  /// =========================
  sl.registerLazySingleton(() => GetWorkerProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWorkerProfileUseCase(sl()));
  sl.registerLazySingleton<WorkerProfileRepository>(
    () => WorkerProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<WorkerProfileRemoteDataSource>(
    () => kUseMockData
        ? FakeWorkerProfileRemoteDataSource()
        : FallbackWorkerProfileRemoteDataSource(
            primary: WorkerProfileRemoteDataSourceImpl(sl()),
            fallback: FakeWorkerProfileRemoteDataSource(),
          ),
  );

  /// =========================
  /// NOTIFICATIONS FEATURE
  /// =========================
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsReadUseCase(sl()));
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  // Pure mock when [kUseMockData]; otherwise live-with-fallback. Singleton so
  // the in-memory read-state persists for the session.
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => kUseMockData
        ? FakeNotificationsRemoteDataSource()
        : FallbackNotificationsRemoteDataSource(
            primary: NotificationsRemoteDataSourceImpl(sl()),
            fallback: FakeNotificationsRemoteDataSource(),
          ),
  );

  /// =========================
  /// SEARCH FEATURE
  /// =========================
  sl.registerLazySingleton(() => SearchServicesUseCase(sl()));
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => kUseMockData
        ? FakeSearchRemoteDataSource()
        : FallbackSearchRemoteDataSource(
            primary: SearchRemoteDataSourceImpl(sl()),
            fallback: FakeSearchRemoteDataSource(),
          ),
  );

  /// =========================
  /// CORE
  /// =========================
  // Always reports "connected" so the repository guard never short-circuits to
  // a ConnectionFailure: the data-source layer now owns the live/offline
  // decision (live data when the backend is reachable, current data when it's
  // not). [NetworkInfoImpl] + [InternetConnectionChecker] remain available for
  // any feature that wants a real connectivity probe.
  sl.registerLazySingleton<NetworkInfo>(() => _AlwaysConnectedNetworkInfo());

  /// =========================
  /// EXTERNAL
  /// =========================
  sl.registerLazySingleton(() => _buildDio());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}

/// Configures the shared [Dio] client: base URL, timeouts, JSON headers, a
/// per-request interceptor (Accept-Language + bearer token) and request/response
/// logging.
Dio _buildDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrlParameters.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        HttpHeader.accept.value: 'application/json',
        HttpHeader.contentType.value: 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers[HttpHeader.acceptLanguage.value] =
            AppLanguageInfo.languageCode;
        if (authToken != null && authToken!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $authToken';
        }
        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true),
  );

  return dio;
}

/// Always-connected [NetworkInfo] used only during the mock-data phase.
class _AlwaysConnectedNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}
