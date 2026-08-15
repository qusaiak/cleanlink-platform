
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'config/language/app_language_info.dart';
import 'config/routes/app_router.dart';
import 'core/config/api_config.dart';
import 'core/network/http_headers.dart';
import 'core/network/network_info.dart';
import 'core/session/login_session.dart';
import 'features/auth/data/datasources/auth_api_service.dart';
import 'features/auth/data/repositories/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/data/datasources/fake_worker_profile_remote_data_source.dart';
import 'features/profile/data/datasources/fallback_worker_profile_remote_data_source.dart';
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
import 'features/tasks/data/datasources/fake_tasks_remote_data_source.dart';
import 'features/tasks/data/datasources/fallback_tasks_remote_data_source.dart';
import 'features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'features/tasks/data/repositories/tasks_repository_impl.dart';
import 'features/tasks/domain/repositories/tasks_repository.dart';
import 'features/tasks/domain/usecases/get_daily_tasks_usecase.dart';
import 'features/tasks/domain/usecases/get_task_by_id_usecase.dart';
import 'features/tasks/domain/usecases/update_task_status_usecase.dart';
import 'features/tasks/domain/usecases/watch_daily_tasks_usecase.dart';
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
///           first (GET/POST against [ApiConfig.baseUrl] → the backend's
///           database) and, whenever the server is unreachable, transparently
///           falls back to the in-memory data — so the data stays as it is
///           today until the backend is actually running.
///
/// Default `false`: the app pulls live data from the database when the backend
/// is up and reachable, and otherwise shows the current data unchanged. The
/// base URL is resolved automatically by [ApiConfig] (or overridden with
/// `--dart-define=BASE_URL=...`); an [authToken] is added after login.
const bool kUseMockData = false;

/// Bearer token sent with authenticated requests.
///
/// Now a thin view over [LoginSession.token] — the single source of truth,
/// which is both in memory and persisted — instead of a standalone variable
/// that could be read after it went stale. Kept under the same name so any code
/// still written against it keeps working.
String? get authToken => LoginSession.token;

set authToken(String? value) => LoginSession.token = value;

/// Extra flag a request can carry to opt OUT of the interceptor's "send the
/// worker back to Login" redirect. Used by background calls (FCM token
/// registration, refreshes) that must never move the user off their screen when
/// they fail.
const String kSkipAuthRedirect = 'skipAuthRedirect';

/// Clears every trace of the signed-in worker: the bearer token and the rest of
/// the persisted [LoginSession], plus all cached singletons (tasks list,
/// profile, etc.) by resetting and rebuilding the service locator. Called on
/// logout so the next session starts clean — and so a rebuilt [Dio] sends no
/// stale token.
///
/// [LoginSession.clear] is awaited BEFORE the rebuild, otherwise
/// [initializeDependencies]'s `restore()` would read back the very values being
/// cleared.
///
/// Does NOT touch Firebase/notification state (that layer owns its own
/// lifecycle).
Future<void> clearSession() async {
  await LoginSession.clear();
  await sl.reset();
  await initializeDependencies();
}

Future<void> initializeDependencies() async {
  await AppLanguageInfo.initialize();

  // Restore the persisted session (token, identity, cached avatar) BEFORE any
  // dependency that could issue a request is registered, so the first
  // authenticated call after a cold start already has its bearer token.
  await LoginSession.restore();

  /// =========================
  /// BLOCS
  /// =========================
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUsecase: sl(),
      // Async on purpose: the bloc AWAITS this, so the token is live *and*
      // written to storage before login is reported as successful (i.e. before
      // the screen navigates or any authenticated call goes out).
      onTokenReceived: LoginSession.saveToken,
    ),
  );
  sl.registerFactory<ProfileBloc>(() => ProfileBloc());
  sl.registerFactory<TasksBloc>(
    () => TasksBloc(
      getDailyTasks: sl(),
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
      // Reuse the tasks use cases (already registered) to derive `busy`.
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
  sl.registerFactory<SearchBloc>(() => SearchBloc(searchServices: sl()));

  /// =========================
  /// AUTH FEATURE
  /// =========================
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiServiceImpl(sl()),
  );

  /// =========================
  /// TASKS FEATURE
  /// =========================
  sl.registerLazySingleton(() => GetDailyTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetTaskByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl()));
  sl.registerLazySingleton(() => WatchDailyTasksUseCase(sl()));

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
  sl.registerLazySingleton(() => UpdateProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => GetSkillsUseCase(sl()));
  sl.registerLazySingleton(() => AttachSkillsUseCase(sl()));
  sl.registerLazySingleton(() => DetachSkillsUseCase(sl()));
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
  // Fails loudly in debug if the host is ever lost/misconfigured, instead of
  // every request dying at send time with "No host specified in URI".
  assert(
    ApiConfig.baseUrl.startsWith('http'),
    'API base URL is not configured: "${ApiConfig.baseUrl}"',
  );

  final dio = Dio(
    BaseOptions(
      // Host root only ([ApiConfig.baseUrl] minus its `/api`) — every path
      // constant carries its own `/api/...`, so a request resolves to
      // `<host>/api/...` exactly once. Without a base URL the paths are
      // relative and Dio fails with "No host specified in URI".
      //
      // Read here, not captured at import time: this client is a LAZY
      // singleton, so it is built on first use — always after
      // `ApiConfig.init()` has run in `main()`, never from a stale value.
      baseUrl: ApiConfig.hostRoot,
      // Cold-start budget. The previous 4s applied to EVERY phase and was
      // routinely blown by the very first request of a session — the emulator's
      // first TCP connect to the host, plus the backend's own cold boot
      // (framework bootstrap + the deliberately slow password hash on login) —
      // which is exactly why the first login attempt failed and the retry,
      // hitting an already-warm server, succeeded.
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        // `Accept: application/json` is what makes Laravel answer with a JSON
        // error envelope. Without it the framework treats the call as a browser
        // request and replies with an HTML page (or a 302 to the login route),
        // which no parser can read a message out of.
        HttpHeader.accept.value: 'application/json',
        HttpHeader.contentType.value: 'application/json',
      },
      responseType: ResponseType.json,
      // Keep the BODY of a non-2xx response. Without this a 401/422 would reach
      // the error handler as a bare exception with `response.data == null` and
      // the server's message would be lost — which is exactly what
      // `parseApiError` needs to read.
      receiveDataWhenStatusError: true,
      // Left at the 2xx range on purpose: the repositories map success →
      // `Right` and failure → `Left(Failure)`, so widening this would hand
      // every data source an error body to parse as if it were a valid
      // payload. Dio still attaches the full response to the thrown
      // DioException, so the body reaches the handler intact either way.
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers[HttpHeader.acceptLanguage.value] =
            AppLanguageInfo.languageCode;
        // Read the token FRESH from the session on every request (never
        // captured in a variable at client-build time), so the first
        // authenticated call after login always carries it.
        final token = LoginSession.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          // Defensive: a rebuilt client must never keep a stale header.
          options.headers.remove('Authorization');
        }
        handler.next(options);
      },
      // Centralized redirect, now limited to an actually-expired session.
      //
      // It used to also fire on any timeout/connection error, which made a
      // slow background call (e.g. the FCM-token registration fired right after
      // login, slow only on a first run) throw the worker back to the Login
      // screen a moment after a SUCCESSFUL login — indistinguishable from
      // "login failed". Transient network errors are now surfaced by the caller
      // (snackbar / fallback data source) instead of moving the user.
      onError: (DioException err, handler) {
        final isUnauthorized = err.response?.statusCode == 401;
        final skipRedirect = err.requestOptions.extra[kSkipAuthRedirect] == true;

        if (isUnauthorized && !skipRedirect) {
          // The session is genuinely gone: drop it (memory + storage) and send
          // the worker back to Login — unless they are already there.
          unawaited(LoginSession.clear());
          _goToLogin();
        }

        handler.next(err);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true),
  );

  return dio;
}

/// Navigates back to Login, no-op when already there or when the router isn't
/// attached yet (a request can fail before the first frame is built).
void _goToLogin() {
  try {
    if (AppRouter.router.state.fullPath == AppRouter.kLogin) return;
  } catch (_) {
    // Router not ready — nothing to redirect away from.
    return;
  }
  AppRouter.router.go(AppRouter.kLogin);
}

/// Always-connected [NetworkInfo] used only during the mock-data phase.
class _AlwaysConnectedNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}
