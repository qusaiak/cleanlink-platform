import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:worker_app/config/routes/route_animation.dart';

import '../../core/widgets/custom_connection_timeout.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/search/domain/entities/search_query.dart';
import '../../features/search/presentation/pages/search_results_page.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../../features/tasks/presentation/pages/task_details_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/worker_profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  /// ===============================
  /// ROUTES
  /// ===============================
  static const kOnboarding = '/onboarding';
  static const kConnectionTimeout = '/connection_timeout';
  static const kLogin = '/login';

  static const kOtp = '/otp';
  static const kResetPassword = '/reset_password';
  static const kChangePassword = '/change_password';

  static const kHome = '/home';
  static const kTaskDetails = '/task_details';
  static const kProfile = '/profile';
  static const kSettings = '/settings';
  static const kNotifications = '/notifications';
  static const kSearch = '/search';

  /// ===============================
  /// NAV KEYS
  /// ===============================
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  /// ===============================
  /// APP STATE (TEMP SAFE FLAGS)
  /// ===============================
  static bool isSplashDone = false;
  static bool isOnboardingDone = false;

  /// ===============================
  /// ROUTER
  /// ===============================
  static final router = GoRouter(
    observers: [MyNavigatorObserver()],
    initialLocation: kOnboarding,
    navigatorKey: rootNavigatorKey,
    routes: [
      /// ================= SPLASH =================
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          isSplashDone = true;
          return const MaterialPage(child: OnboardingPage());
        },
      ),

      GoRoute(
        path: kConnectionTimeout,
        pageBuilder: (context, state) {
          isSplashDone = true;
          return const MaterialPage(child: CustomConnectionTimeout());
        },
      ),

      /// ================= ONBOARDING =================
      GoRoute(
        path: kOnboarding,
        pageBuilder: (context, state) {
          isSplashDone = true;
          isOnboardingDone = true;
          return const MaterialPage(child: OnboardingPage());
        },
      ),

      /// ================= LOGIN =================
      GoRoute(
        path: kLogin,
        pageBuilder: (context, state) {
          isSplashDone = true;
          isOnboardingDone = true;
          return MaterialPage(child: LoginPage());
        },
      ),

      GoRoute(
        path: kOtp,
        pageBuilder: (context, state) {
          final phone = (state.extra as String?) ?? '';
          return slideTransitionHorizontal(OtpPage(phone: phone,));
        },
      ),
      GoRoute(
        path: kChangePassword,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const ChangePasswordPage()),
      ),

      /// ================= TASK DETAILS =================
      /// Pushed over the home screen; the [Task] is passed via `extra`.
      GoRoute(
        path: kTaskDetails,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          TaskDetailsPage(task: state.extra as Task),
        ),
      ),

      /// ================= HOME =================
      /// The single main screen. Profile/Settings are reached from its drawer.
      GoRoute(
        path: kHome,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(HomePage(key: state.pageKey)),
      ),

      /// ================= PROFILE =================
      GoRoute(
        path: kProfile,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(WorkerProfilePage(key: state.pageKey)),
      ),

      /// ================= SETTINGS =================
      GoRoute(
        path: kSettings,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(SettingsPage(key: state.pageKey)),
      ),

      /// ================= NOTIFICATIONS =================
      /// Pushed from the top-bar bell on the home screen.
      GoRoute(
        path: kNotifications,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(NotificationsPage(key: state.pageKey)),
      ),

      /// ================= SEARCH =================
      /// Pushed from the top-bar search field; the chosen [SearchQuery] is
      /// passed via `extra` and run on open.
      GoRoute(
        path: kSearch,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          SearchResultsPage(
            key: state.pageKey,
            initialQuery: state.extra as SearchQuery?,
          ),
        ),
      ),
    ],

    /// ===============================
    /// REDIRECT (FIXED LOGIC)
    /// ===============================
    // redirect: (context, state) async {
    //   debugPrint(state.fullPath);
    //   if (!isSplashDone) {
    //     return '/';
    //   }
    //   if (!isOnboardingDone) {
    //     return kOnboarding;
    //   }
    //   // if (!await SharedStorage.authenticated && state.fullPath == kHome) {
    //   //   return kLogin;
    //   // }
    //   return null;
    // },
  );

  static String returnFullPath() {
    return AppRouter.router.state.fullPath!;
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    log('PUSH: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    log('POP: ${route.settings.name}');
  }
}
