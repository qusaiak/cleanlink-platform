import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:worker_app/config/routes/route_animation.dart';

import '../../core/widgets/custom_connection_timeout.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/base/presentation/pages/base_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';

class AppRouter {
  /// ===============================
  /// ROUTES
  /// ===============================
  static const kOnboarding = '/onboarding';
  static const kConnectionTimeout = '/connection_timeout';
  static const kLogin = '/login';
  static const kRegister = '/register';
  static const kOtp = '/otp';
  static const kResetPassword = '/reset_password';
  static const kChangePassword = '/change_password';

  static const kHome = '/home';
  static const kSearch = '/search';
  static const kHistory = '/history';
  static const kProfile = '/profile';

  /// ===============================
  /// NAV KEYS
  /// ===============================
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _homeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _searchKey = GlobalKey<NavigatorState>(debugLabel: 'search');
  static final _historyKey = GlobalKey<NavigatorState>(debugLabel: 'history');
  static final _profileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

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
    initialLocation: '/',
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
          return const MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        path: kRegister,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const RegisterPage()),
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

      /// ================= SHELL NAV =================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BasePage(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          /// HOME
          StatefulShellBranch(
            navigatorKey: _homeKey,
            routes: [
              GoRoute(
                path: kHome,
                pageBuilder: (context, state) =>
                    slideTransitionHorizontal(HomePage(key: state.pageKey)),
              ),
            ],
          ),

          /// SEARCH
          StatefulShellBranch(
            navigatorKey: _searchKey,
            routes: [
              GoRoute(
                path: kSearch,
                pageBuilder: (context, state) =>
                    slideTransitionHorizontal(SearchPage(key: state.pageKey)),
              ),
            ],
          ),

          /// HISTORY
          StatefulShellBranch(
            navigatorKey: _historyKey,
            routes: [
              GoRoute(
                path: kHistory,
                pageBuilder: (context, state) =>
                    slideTransitionHorizontal(HistoryPage(key: state.pageKey)),
              ),
            ],
          ),

          /// PROFILE
          StatefulShellBranch(
            navigatorKey: _profileKey,
            routes: [
              GoRoute(
                path: kProfile,
                pageBuilder: (context, state) =>
                    slideTransitionHorizontal(ProfilePage(key: state.pageKey)),
              ),
            ],
          ),
        ],
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
