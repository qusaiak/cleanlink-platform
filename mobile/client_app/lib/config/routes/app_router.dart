import 'dart:developer';

import 'package:client_app/config/routes/route_animation.dart';
import 'package:client_app/core/widgets/custom_connection_timeout.dart';
import 'package:client_app/features/auth/presentation/pages/change_password_page.dart';
import 'package:client_app/features/auth/presentation/pages/login_page.dart';
import 'package:client_app/features/auth/presentation/pages/otp_page.dart';
import 'package:client_app/features/auth/presentation/pages/register_page.dart';
import 'package:client_app/features/base/presentation/pages/base_page.dart';
import 'package:client_app/features/bookings/presentation/pages/bookings_page.dart';
import 'package:client_app/features/companies/presentation/pages/companies_page.dart';
import 'package:client_app/features/companies/presentation/pages/company_details_page.dart';
import 'package:client_app/features/home/presentation/pages/home_page.dart';
import 'package:client_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:client_app/features/profile/presentation/pages/contact_us_page.dart';
import 'package:client_app/features/profile/presentation/pages/help_center_page.dart';
import 'package:client_app/features/profile/presentation/pages/profile_page.dart';
import 'package:client_app/features/search/presentation/pages/search_page.dart';
import 'package:client_app/features/services/presentation/pages/service_details_page.dart';
import 'package:client_app/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/categories/presentation/pages/categories_page.dart';

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
  static const kContactUs = '/contact_us';
  static const kHelpCenter = '/help_center';

  static const kAppContentPage = '/content';

  static const kCompanies = '/companies';
  static const kServices = '/services';
  static const kCategories = '/categories';
  static const kRegions = '/regions';
  static const kProviders = '/providers';
  static const kOffers = '/offers';

  static const kCompanyDetails = '/company';
  static const kServiceDetails = '/service';
  static const kCategoryDetails = '/category';
  static const kRegionDetails = '/region';
  static const kProviderDetails = '/provider';
  static const kOfferDetails = '/offer';

  static const kHome = '/home';
  static const kSearch = '/search';
  static const kBookings = '/bookings';
  static const kProfile = '/profile';

  /// ===============================
  /// NAV KEYS
  /// ===============================
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _homeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _searchKey = GlobalKey<NavigatorState>(debugLabel: 'search');
  static final _bookingsKey = GlobalKey<NavigatorState>(debugLabel: 'bookings');
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
    initialLocation: kHome,
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
          return slideTransitionHorizontal(OtpPage(phone: phone));
        },
      ),
      GoRoute(
        path: kChangePassword,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const ChangePasswordPage()),
      ),
      GoRoute(
        path: kContactUs,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const ContactUsPage()),
      ),
      GoRoute(
        path: kHelpCenter,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const HelpCenterPage()),
      ),
      GoRoute(
        path: kCategories,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const CategoriesPage()),
      ),
      GoRoute(
        path: kCompanies,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const CompaniesPage()),
      ),
      GoRoute(
        path: kServices,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const ServicesPage()),
      ),
      GoRoute(
        path: kCompanyDetails,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const CompanyDetailsPage()),
      ),
      GoRoute(
        path: kServiceDetails,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const ServiceDetailsPage()),
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

          /// BOOKINGS
          StatefulShellBranch(
            navigatorKey: _bookingsKey,
            routes: [
              GoRoute(
                path: kBookings,
                pageBuilder: (context, state) =>
                    slideTransitionHorizontal(BookingsPage(key: state.pageKey)),
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
