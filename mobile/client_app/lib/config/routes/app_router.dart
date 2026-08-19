import 'dart:developer';

import 'package:client_app/config/routes/route_animation.dart';
import 'package:client_app/core/widgets/custom_connection_timeout.dart';
import 'package:client_app/features/auth/presentation/pages/change_password_page.dart';
import 'package:client_app/features/auth/presentation/pages/login_page.dart';
import 'package:client_app/features/auth/presentation/pages/otp_page.dart';
import 'package:client_app/features/auth/presentation/pages/personal_details_page.dart';
import 'package:client_app/features/auth/presentation/pages/register_page.dart';
import 'package:client_app/features/auth/domain/entities/pending_registration_data.dart';
import 'package:client_app/features/base/presentation/pages/base_page.dart';
import 'package:client_app/features/bookings/presentation/pages/my_bookings_page.dart';
import 'package:client_app/features/bookings/presentation/pages/order_details_page.dart';
import 'package:client_app/features/companies/presentation/pages/companies_page.dart';
import 'package:client_app/features/companies/presentation/pages/company_details_page.dart';
import 'package:client_app/features/complaints/presentation/pages/complaint_details_page.dart';
import 'package:client_app/features/complaints/presentation/pages/complaints_page.dart';
import 'package:client_app/features/favorites/presentation/pages/favorites_page.dart';
import 'package:client_app/features/reviews/presentation/pages/my_reviews_page.dart';
import 'package:client_app/features/home/presentation/pages/home_page.dart';
import 'package:client_app/features/notification/presentation/pages/notifications_page.dart';
import 'package:client_app/features/locations/domain/entities/selected_map_location.dart';
import 'package:client_app/features/locations/presentation/pages/map_location_picker_page.dart';
import 'package:client_app/features/locations/domain/entities/client_location_entity.dart';
import 'package:client_app/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:client_app/features/locations/presentation/pages/location_editor_page.dart';
import 'package:client_app/features/locations/presentation/pages/locations_page.dart';
import 'package:client_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:client_app/features/profile/presentation/pages/contact_us_page.dart';
import 'package:client_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:client_app/features/profile/presentation/pages/help_center_page.dart';
import 'package:client_app/features/profile/presentation/pages/profile_page.dart';
import 'package:client_app/features/payments/presentation/bloc/payment_history_bloc.dart';
import 'package:client_app/features/payments/presentation/pages/payment_history_page.dart';
import 'package:client_app/features/search/presentation/pages/search_page.dart';
import 'package:client_app/features/services/presentation/pages/offers_page.dart';
import 'package:client_app/features/services/presentation/pages/service_details_page.dart';
import 'package:client_app/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../injection_container.dart';

import '../../core/storage/shared_storage.dart';
import '../../core/storage/storage_data.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/categories/presentation/pages/category_details_page.dart';
import '../../features/regions/presentation/pages/region_page.dart';
import '../../features/regions/presentation/pages/regions_page.dart';

class AppRouter {
  /// ===============================
  /// ROUTES
  /// ===============================
  static const kRoot = '/';

  static const kOnboarding = '/onboarding';
  static const kConnectionTimeout = '/connection_timeout';
  static const kLogin = '/login';
  static const kRegister = '/register';
  static const kPersonalDetails = '/personal_details';
  static const kOtp = '/otp';
  static const kFavorites = '/favorites';
  static const kMyReviews = '/my-reviews';
  static const kNotifications = '/notifications';
  static const kComplaints = '/complaints';
  static const kComplaintDetails = '/complaints/:complaintId';
  static String complaintDetailsPath(int complaintId) =>
      '/complaints/$complaintId';
  static const kResetPassword = '/reset_password';
  static const kChangePassword = '/change_password';
  static const kContactUs = '/contact_us';
  static const kHelpCenter = '/help_center';
  static const kEditProfile = '/profile/edit';
  static const kMapLocationPicker = '/locations/map-picker';
  static const kLocations = '/locations';
  static const kAddLocation = '/locations/add';
  static const kEditLocation = '/locations/edit';

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
  static const kOrderDetails = '/orders/:orderId';
  static String orderDetailsPath(int orderId) => '/orders/$orderId';
  static const kProfile = '/profile';
  static const kPaymentHistory = '/payments';

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
    initialLocation: kRoot,
    navigatorKey: rootNavigatorKey,
    routes: [
      /// ================= SPLASH =================
      GoRoute(
        path: kRoot,
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
        path: kPersonalDetails,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const PersonalDetailsPage()),
      ),
      GoRoute(
        path: kOtp,
        redirect: (context, state) =>
            state.extra is PendingRegistrationData ? null : kRegister,
        pageBuilder: (context, state) {
          final pending = state.extra! as PendingRegistrationData;
          return slideTransitionHorizontal(
            OtpPage(pendingRegistration: pending),
          );
        },
      ),
      GoRoute(
        path: kChangePassword,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const ChangePasswordPage()),
      ),
      GoRoute(
        path: kPaymentHistory,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          BlocProvider<PaymentHistoryBloc>(
            create: (_) => sl(),
            child: const PaymentHistoryPage(),
          ),
        ),
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
        path: kEditProfile,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const EditProfilePage()),
      ),
      GoRoute(
        path: kMapLocationPicker,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          MapLocationPickerPage(
            initialLocation: state.extra is SelectedMapLocation
                ? state.extra! as SelectedMapLocation
                : null,
          ),
        ),
      ),
      GoRoute(
        path: kLocations,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          BlocProvider.value(
            value: sl<LocationsBloc>(),
            child: const LocationsPage(),
          ),
        ),
      ),
      GoRoute(
        path: kAddLocation,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          BlocProvider.value(
            value: sl<LocationsBloc>(),
            child: const LocationEditorPage(),
          ),
        ),
      ),
      GoRoute(
        path: kEditLocation,
        redirect: (context, state) =>
            state.extra is ClientLocationEntity ? null : kLocations,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          BlocProvider.value(
            value: sl<LocationsBloc>(),
            child: LocationEditorPage(
              location: state.extra! as ClientLocationEntity,
            ),
          ),
        ),
      ),
      GoRoute(
        path: kFavorites,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const FavoritesPage()),
      ),
      GoRoute(
        path: kMyReviews,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const MyReviewsPage()),
      ),
      GoRoute(
        path: kNotifications,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const NotificationsPage()),
      ),
      GoRoute(
        path: kComplaints,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const ComplaintsPage()),
      ),
      GoRoute(
        path: kComplaintDetails,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          ComplaintDetailsPage(
            complaintId: int.parse(state.pathParameters['complaintId']!),
          ),
        ),
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
        path: kRegions,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const RegionsPage()),
      ),
      GoRoute(
        path: kRegionDetails,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(RegionPage(regionId: state.extra as int)),
      ),
      GoRoute(
        path: kProviders,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const CompaniesPage()),
      ),
      GoRoute(
        path: kOffers,
        pageBuilder: (context, state) =>
            slideTransitionHorizontal(const OffersPage()),
      ),
      GoRoute(
        path: kCompanyDetails,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          CompanyDetailsPage(id: state.extra as int),
        ),
      ),
      GoRoute(
        path: kServiceDetails,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          ServiceDetailsPage(id: state.extra as int),
        ),
      ),
      GoRoute(
        path: kCategoryDetails,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          CategoryDetailsPage(categoryId: state.extra as int),
        ),
      ),
      GoRoute(
        path: kOrderDetails,
        pageBuilder: (context, state) => slideTransitionHorizontal(
          OrderDetailsPage(
            orderId: int.parse(state.pathParameters['orderId']!),
          ),
        ),
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
                pageBuilder: (context, state) => slideTransitionHorizontal(
                  MyBookingsPage(key: state.pageKey),
                ),
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
    /// REDIRECT
    /// ===============================
    redirect: (context, state) async {
      final location = state.fullPath;

      final onboardingDone = await SharedStorage.hasData(
        StorageData.isOnboarding,
      );

      final authenticated = await SharedStorage.authenticated;

      debugPrint('''
Location: $location
Onboarding: $onboardingDone
Auth: $authenticated
''');

      /// FIRST RUN
      if (!onboardingDone && location != kOnboarding) {
        return kOnboarding;
      }

      /// AFTER ONBOARDING
      if (onboardingDone &&
          !authenticated &&
          location != kLogin &&
          location != kRegister &&
          location != kOtp) {
        return kLogin;
      }

      /// LOGGED IN
      if (authenticated &&
          (location == kLogin ||
              location == kRegister ||
              location == kOnboarding ||
              location == kRoot)) {
        return kHome;
      }

      return null;
    },
  );

  static String returnFullPath() {
    return router.state.fullPath ?? kRoot;
  }

  static Future<void> openOrderDetailsFromExternalNotification(
    int orderId,
  ) async {
    for (var attempt = 0; attempt < 10; attempt++) {
      if (rootNavigatorKey.currentContext != null) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    router.go(kHome);
    await Future<void>.delayed(Duration.zero);
    router.push(orderDetailsPath(orderId));
  }

  static Future<void> openComplaintDetailsFromExternalNotification(
    int complaintId,
  ) async {
    for (var attempt = 0; attempt < 10; attempt++) {
      if (rootNavigatorKey.currentContext != null) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    router.go(kHome);
    await Future<void>.delayed(Duration.zero);
    router.push(complaintDetailsPath(complaintId));
  }
}

//   /// ===============================
//   /// REDIRECT (FIXED LOGIC)
//   /// ===============================
//   redirect: (context, state) async {
//     debugPrint("fullPath: ${state.fullPath}");
//     // if (!isSplashDone) {
//     //   return '/';
//     // }
//     if (!await SharedStorage.hasData(StorageData.isOnboarding)) {
//       return kOnboarding;
//     }
//     if (!await SharedStorage.authenticated && state.fullPath == kHome) {
//       return kLogin;
//     }
//     return null;
//   },
// );
//   static String returnFullPath() {
//     return AppRouter.router.state.fullPath!;
//   }
// }

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
