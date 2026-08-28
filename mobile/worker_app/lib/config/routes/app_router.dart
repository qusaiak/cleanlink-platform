import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:worker_app/config/routes/route_animation.dart';

import '../../core/session/app_startup.dart';
import '../../core/session/login_session.dart';
import '../../core/widgets/custom_connection_timeout.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../../features/tasks/presentation/pages/task_details_page.dart';
import '../../features/tasks/presentation/pages/task_map_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/worker_profile_page.dart';
import '../../features/profile/presentation/pages/my_skills_page.dart';
import '../../features/profile/presentation/bloc/worker_profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static const kSplash = '/';
  static const kOnboarding = '/onboarding';
  static const kConnectionTimeout = '/connection_timeout';
  static const kLogin = '/login';

  static const kChangePassword = '/change_password';

  static const kHome = '/home';
  static const kTaskDetails = '/task_details';
  static const kTaskMap = '/task_map';
  static const kProfile = '/profile';
  static const kSettings = '/settings';
  static const kNotifications = '/notifications';
  static const kSkills = '/my-skills';

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = _buildRouter();

  static GoRouter _buildRouter() {
    final goRouter = GoRouter(
      observers: [MyNavigatorObserver()],
      initialLocation: kSplash,
      navigatorKey: rootNavigatorKey,
      routes: _routes,
    );

    goRouter.routerDelegate.addListener(() => _logInterfacePath(goRouter));

    return goRouter;
  }

  static void _logInterfacePath(GoRouter goRouter) {
    final config = goRouter.routerDelegate.currentConfiguration;

    final layers = config.matches.map((match) {
      final route = match.route;
      return route is GoRoute ? route.path : route.runtimeType.toString();
    }).toList();

    log('🧭 INTERFACE: ${layers.join(' → ')}  (full: ${config.uri})');
  }

  static final List<RouteBase> _routes = [
    GoRoute(
      path: kSplash,
      redirect: (context, state) => !AppStartup.onboardingCompleted
          ? kOnboarding
          : LoginSession.hasToken
          ? kHome
          : kLogin,
    ),

    GoRoute(
      path: kConnectionTimeout,
      pageBuilder: (context, state) {
        return const MaterialPage(child: CustomConnectionTimeout());
      },
    ),

    GoRoute(
      path: kOnboarding,
      pageBuilder: (context, state) {
        return const MaterialPage(child: OnboardingPage());
      },
    ),

    GoRoute(
      path: kLogin,
      pageBuilder: (context, state) {
        return MaterialPage(child: LoginPage());
      },
    ),

    GoRoute(
      path: kChangePassword,
      pageBuilder: (context, state) =>
          slideTransitionHorizontal(const ChangePasswordPage()),
    ),

    GoRoute(
      path: kTaskDetails,
      pageBuilder: (context, state) =>
          slideTransitionHorizontal(TaskDetailsPage(task: state.extra as Task)),
    ),

    GoRoute(
      path: kTaskMap,
      pageBuilder: (context, state) =>
          slideTransitionHorizontal(TaskMapPage(task: state.extra as Task)),
    ),

    GoRoute(
      path: kHome,
      pageBuilder: (context, state) =>
          slideTransitionHorizontal(HomePage(key: state.pageKey)),
    ),

    GoRoute(
      path: kProfile,
      pageBuilder: (context, state) =>
          slideTransitionHorizontal(WorkerProfilePage(key: state.pageKey)),
    ),

    GoRoute(
      path: kSettings,
      pageBuilder: (context, state) =>
          slideTransitionHorizontal(SettingsPage(key: state.pageKey)),
    ),

    GoRoute(
      path: kNotifications,
      pageBuilder: (context, state) =>
          slideTransitionHorizontal(NotificationsPage(key: state.pageKey)),
    ),
    GoRoute(
      path: kSkills,
      pageBuilder: (context, state) => slideTransitionHorizontal(
        BlocProvider.value(
          value: state.extra as WorkerProfileBloc,
          child: const MySkillsPage(),
        ),
      ),
    ),
  ];

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
