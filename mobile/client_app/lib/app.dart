import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/config/theme/app_themes.dart';
import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:client_app/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:client_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:client_app/features/companies/presentation/bloc/companies_bloc.dart';
import 'package:client_app/features/complaints/presentation/bloc/complaints_bloc.dart';
import 'package:client_app/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:client_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:client_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:client_app/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:client_app/features/regions/presentation/bloc/regions_bloc.dart';
import 'package:client_app/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:client_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:client_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:client_app/injection_container.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/widgets/custom_toast.dart';
import 'config/theme/app_theme_info.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'l10n/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (BuildContext context) => sl()),
        BlocProvider<BaseBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ProfileBloc>(create: (BuildContext context) => sl()),
        BlocProvider<BookingsBloc>(create: (BuildContext context) => sl()),
        BlocProvider<PaymentsBloc>(create: (BuildContext context) => sl()),
        BlocProvider<HomeBloc>(create: (BuildContext context) => sl()),
        BlocProvider<CompaniesBloc>(create: (BuildContext context) => sl()),
        BlocProvider<CategoriesBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ServicesBloc>(create: (BuildContext context) => sl()),
        BlocProvider<RegionsBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ReviewBloc>(create: (BuildContext context) => sl()),
        BlocProvider<FavoritesBloc>(create: (BuildContext context) => sl()),
        BlocProvider<SearchBloc>(create: (BuildContext context) => sl()),
        BlocProvider<NotificationsBloc>.value(value: sl()),
        BlocProvider<ComplaintsBloc>.value(value: sl()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
                title: 'CleanLink',
                theme: lightTheme(),
                darkTheme: darkTheme(),
                themeMode: AppThemeInfo.isLight
                    ? ThemeMode.light
                    : ThemeMode.dark,
                locale: Locale(state.languageCode),
                supportedLocales: L10n.all,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
